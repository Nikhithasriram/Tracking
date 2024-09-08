// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:tracking_app/models/dialysisclass.dart';
import 'package:uuid/uuid.dart';
import 'package:tracking_app/functions/mydatetime.dart';

class DatabaseDialysis {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final String _netml = "netml";
  final String _date = "date";
  final String _session = "session";
  final String _inml = "inml";
  final String _outml = "outml";
  final String _time = "time";
  final String _sessionnet = "sessionnet";
  final String _notes = "notes";
  final String _uuid = "uuid";
  final String _sortingTimestamp = "sortingtimestamp";

  Stream<List<DialysisReading>> get dialysis {
    return users
        .doc(_auth.currentUser!.uid)
        .collection('PD')
        .orderBy(_sortingTimestamp, descending: true)
        .snapshots()
        .map(_convertoDialysisReading)
        .handleError((e) {
      // print(e);
    });
  }

  Future<List<DialysisReading>> dialysisReadingBetweenDates(
      DateTime start, DateTime end) async {
    final betweendatesdocs = await users
        .doc(_auth.currentUser!.uid)
        .collection('PD')
        .where(_sortingTimestamp,
            isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where(_sortingTimestamp, isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy(
          _sortingTimestamp,
        )
        .get();
    return _convertoDialysisReading(betweendatesdocs);
  }

  Future<DialysisReading?> pdreading({required String uuid}) async {
    final pd = users.doc(_auth.currentUser!.uid).collection('PD');
    final sameuuid = await pd.where(_uuid, isEqualTo: uuid).get();
    final docsnapshots = sameuuid.docs;
    // print("nice");
    if (docsnapshots.isNotEmpty) {
      String docid = docsnapshots[0].id;
      // print("nice1");

      final reading = await pd.doc(docid).get();
      // print(reading[_session]);
      print(reading[_netml]);
      return DialysisReading(
          netml: (reading.get(_netml) as num).toDouble(),
          date: reading[_date],
          session: _convertToOneSession(reading[_session]),
          uuid: uuid,
          sortingtimestamp: reading[_sortingTimestamp]);
    }
    return null;
  }

  Future<Onesession?> onesessionreading(
      {required String uuid, required String subuuid}) async {
    final pd = users.doc(_auth.currentUser!.uid).collection('PD');
    final sameuuid = await pd.where(_uuid, isEqualTo: uuid).get();
    final docsnapshots = sameuuid.docs;
    if (docsnapshots.isNotEmpty) {
      String docid = docsnapshots[0].id;
      final reading = await pd.doc(docid).get();
      final session = reading[_session];
      for (var i in session) {
        if (i[_uuid] == subuuid) {
          return Onesession(
              inml: (i[_inml] as num).toDouble(),
              outml: (i[_outml] as num).toDouble(),
              date: i[_date],
              time: i[_time],
              sessionnet: (i[_sessionnet] as num).toDouble(),
              notes: i[_notes],
              uuid: subuuid);
        }
      }
    }
    return null;
  }

  Future<void> add({
    required double inml,
    required double outml,
    required String date,
    required String time,
    required String notes,
  }) async {
    final pd = users.doc(_auth.currentUser!.uid).collection('PD');
    final samedate = await pd.where(_date, isEqualTo: date).get();
    final docsnapshots = samedate.docs;
    if (docsnapshots.isNotEmpty) {
      String docid = docsnapshots[0].id;
      final reading = await pd.doc(docid).get();
      final List onesession = reading[_session];
      final addedreading = _addaccordingtotime(
          onesession,
          Onesession(
              inml: inml,
              outml: outml,
              date: date,
              time: time,
              sessionnet: 0,
              notes: notes,
              uuid: const Uuid().v4()));
      double netml = 0;
      for (int i = 0; i < addedreading.length; i++) {
        netml = netml + addedreading[i][_sessionnet];
      }
      pd.doc(docid).update({
        _netml: netml,
        _session: addedreading,
      });
    } else {
      pd.add({
        _netml: 0,
        _date: date,
        _uuid: const Uuid().v4(),
        _sortingTimestamp: Timestamp.fromDate(mydatetime(date, "1:00 pm")),
        _session: [
          {
            _inml: inml,
            _outml: outml,
            _time: time,
            _uuid: const Uuid().v4(),
            _notes: notes,
            _date: date,
            _sessionnet: 0,
          }
        ]
      });
    }
  }

  Future<void> delete({required String uuid, required String subuuid}) async {
    final pd = users.doc(_auth.currentUser!.uid).collection('PD');
    final samedate = await pd.where(_uuid, isEqualTo: uuid).get();
    final samedatedocs = samedate.docs;
    if (samedatedocs.isNotEmpty) {
      final docid = samedatedocs.first.id;
      final doc = await pd.doc(docid).get();
      final sessionmap = doc[_session];
      final newsessionmap = sessionmap.where((e) {
        return e[_uuid] != subuuid;
      }).toList();
      for (int i = 1; i < newsessionmap.length; i++) {
        newsessionmap[i][_sessionnet] =
            newsessionmap[i][_outml] - newsessionmap[i - 1][_inml];
      }
      if (newsessionmap.length > 0) {
        newsessionmap[0][_sessionnet] = 0;
      }
      double newnetml = 0;
      for (var i in newsessionmap) {
        newnetml = newnetml + i[_sessionnet];
      }
      if (newsessionmap.length == 0) {
        await pd.doc(docid).delete();
      } else {
        pd.doc(docid).update({
          _netml: newnetml,
          _session: newsessionmap,
        });
      }
    }
  }

  Future<void> update(
      {required String uuid,
      required String subuuid,
      required Onesession reading}) async {
    final pd = users.doc(_auth.currentUser!.uid).collection('PD');
    final samedate = await pd.where(_uuid, isEqualTo: uuid).get();
    final samedatedocs = samedate.docs;
    if (samedatedocs.isNotEmpty) {
      final docid = samedatedocs.first.id;
      final doc = await pd.doc(docid).get();
      final sessionmap = doc[_session];
      var newsessionmap = sessionmap.where((e) {
        return e[_uuid] != subuuid;
      }).toList();
      for (int i = 1; i < newsessionmap.length; i++) {
        newsessionmap[i][_sessionnet] =
            newsessionmap[i][_outml] - newsessionmap[i - 1][_inml];
      }
      newsessionmap = _addaccordingtotime(newsessionmap, reading);
      double newnetml = 0;
      for (var i in newsessionmap) {
        newnetml = newnetml + i[_sessionnet];
      }
      pd.doc(docid).update({
        _netml: newnetml,
        _session: newsessionmap,
      });
    }
  }

  List<DialysisReading> _convertoDialysisReading(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return DialysisReading(
          netml: (e.get(_netml) as num).toDouble(),
          date: e.get(_date),
          session: _convertToOneSession(e.get(_session)),
          uuid: e.get(_uuid),
          sortingtimestamp: e.get(_sortingTimestamp));
    }).toList();
  }

  List<Onesession> _convertToOneSession(List onesession) {
    return onesession.map((e) {
      return Onesession(
          inml: (e[_inml] as num).toDouble(),
          outml: (e[_outml] as num).toDouble(),
          date: e[_date],
          time: e[_time],
          sessionnet: (e[_sessionnet] as num).toDouble(),
          notes: e[_notes] ?? "",
          uuid: e[_uuid]);
    }).toList();
  }

  List<Map<dynamic, dynamic>> _converttomap(List<Onesession> onesession) {
    return onesession.map((e) {
      return {
        _inml: e.inml,
        _outml: e.outml,
        _date: e.date,
        _time: e.time,
        _notes: e.notes,
        _uuid: e.uuid,
        _sessionnet: e.sessionnet,
      };
    }).toList();
  }

  List<Map<dynamic, dynamic>> _addaccordingtotime(
      List onesession, Onesession reading) {
    final onesessionarray = _convertToOneSession(onesession);
    DateTime readingdatetime = mydatetime(reading.date, reading.time);
    bool added = false;
    if (onesessionarray.isEmpty) {
      added = true;
      onesessionarray.add(Onesession(
          inml: reading.inml,
          outml: reading.outml,
          date: reading.date,
          time: reading.time,
          sessionnet: 0,
          notes: reading.notes,
          uuid: reading.uuid));
    }
    if (added == false) {
      for (int i = 0; i < onesessionarray.length - 1; i++) {
        DateTime loopdatetime =
            mydatetime(onesessionarray[i].date, onesessionarray[i].time);
        DateTime nextloopdatetime = mydatetime(
            onesessionarray[i + 1].date, onesessionarray[i + 1].time);
        if (readingdatetime == loopdatetime) {
          // print("something in going onnnn");
          added = true;
          onesessionarray.insert(
            i + 1,
            Onesession(
                inml: reading.inml,
                outml: reading.outml,
                date: reading.date,
                time: reading.time,
                sessionnet: 0,
                notes: reading.notes,
                uuid: reading.uuid),
          );
          break;
        } else if ((readingdatetime.isAfter(loopdatetime) &&
            readingdatetime.isBefore(nextloopdatetime))) {
          // double sessionnet = reading.outml - onesessionarray[i].inml;
          // print("something");
          added = true;
          onesessionarray.insert(
            i + 1,
            Onesession(
                inml: reading.inml,
                outml: reading.outml,
                date: reading.date,
                time: reading.time,
                sessionnet: 0,
                notes: reading.notes,
                uuid: reading.uuid),
          );
          break;
        }
      }
    }
    if (added == false && onesessionarray.length == 1) {
      added = true;
      if (readingdatetime.isAfter(
          mydatetime(onesessionarray[0].date, onesessionarray[0].time))) {
        onesessionarray.add(Onesession(
            inml: reading.inml,
            outml: reading.outml,
            date: reading.date,
            time: reading.time,
            sessionnet: 0,
            notes: reading.notes,
            uuid: reading.uuid));
      } else {
        onesessionarray.insert(
            0,
            Onesession(
                inml: reading.inml,
                outml: reading.outml,
                date: reading.date,
                time: reading.time,
                sessionnet: 0,
                notes: reading.notes,
                uuid: reading.uuid));
      }
    }
    if (added == false) {
      added = true;
      // double sessionnet = reading.outml - onesessionarray[0].inml;
      onesessionarray.add(Onesession(
          inml: reading.inml,
          outml: reading.outml,
          date: reading.date,
          time: reading.time,
          sessionnet: 0,
          notes: reading.notes,
          uuid: reading.uuid));
    }
    for (int i = 1; i < onesessionarray.length; i++) {
      onesessionarray[i].sessionnet =
          onesessionarray[i].outml - onesessionarray[i - 1].inml;
    }
    onesessionarray[0].sessionnet = 0;
    return _converttomap(onesessionarray);
  }
}
