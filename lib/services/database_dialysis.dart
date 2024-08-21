// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:tracking_app/models/dialysis.dart';
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

  Stream<List<DialysisReading>> get dialysis {
    return users
        .doc(_auth.currentUser!.uid)
        .collection('PD')
        .snapshots()
        .map(_convertoDialysisReading)
        .handleError((e) {
      print(e);
    });
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
        _session: [
          {
            _inml: inml,
            _outml: outml,
            _time: time,
            _uuid: const Uuid().v4(),
            _notes: notes,
            _date:date,
            _sessionnet: 0,
          }
        ]
      });
    }
  }

  List<DialysisReading> _convertoDialysisReading(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return DialysisReading(
          netml: (e.get(_netml) as num).toDouble(),
          date: e.get(_date),
          session: _convertToOneSession(e.get(_session)),
          uuid: e.get(_uuid));
    }).toList();
  }

  List<Onesession> _convertToOneSession(List onesession) {
    return onesession.map((e) {
      return Onesession(
          inml: (e[_inml] as num).toDouble() ,
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
    for (int i = onesessionarray.length - 1; i >= 0; i--) {
      DateTime loopdatetime =
          mydatetime(onesessionarray[i].date, onesessionarray[i].time);
      if (readingdatetime.isAfter(loopdatetime) ||
          readingdatetime == loopdatetime) {
        added = true;
        double sessionnet = reading.outml - onesessionarray[i].inml;
        if (i == onesessionarray.length - 1) {
          onesessionarray.add(Onesession(
              inml: reading.inml,
              outml: reading.outml,
              date: reading.date,
              time: reading.time,
              sessionnet: sessionnet,
              notes: reading.notes,
              uuid: reading.uuid));
          // _items[index].netml += sessionnet;
        } else {
          onesessionarray.insert(
              i + 1,
              Onesession(
                  inml: reading.inml,
                  outml: reading.outml,
                  date: reading.date,
                  time: reading.time,
                  sessionnet: sessionnet,
                  notes: reading.notes,
                  uuid: reading.uuid));
          // _items[index].netml += sessionnet;
        }

        break;
      }
    }
    if (added == false) {
      if (onesessionarray.isEmpty) {
        onesessionarray.add(Onesession(
            inml: reading.inml,
            outml: reading.outml,
            date: reading.date,
            time: reading.time,
            sessionnet: 0,
            notes: reading.notes,
            uuid: reading.uuid));
        // _items[index].netml += 0;
      } else {
        double sessionnet = reading.outml - onesessionarray[-2].inml;
        onesessionarray.add(Onesession(
            inml: reading.inml,
            outml: reading.outml,
            date: reading.date,
            time: reading.time,
            sessionnet: sessionnet,
            notes: reading.notes,
            uuid: reading.uuid));
        // _items[index].netml += sessionnet;
      }
    }
    return _converttomap(onesessionarray);
  }
}
