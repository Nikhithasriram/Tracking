import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracking_app/models/waterclass.dart';
import 'package:uuid/uuid.dart';

class DatabaseWater {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final String wvalue = "value";
  final String wtime = "time";
  final String wdate = "date";
  final String wnotes = "notes";
  final String wdayContents = "dayContents";
  final String wuuid = "uuid";
  final String wintakeml = "intakeml";
  final String woutputml = "outputml";
  final String wtype = "wtype";

  Future<DayWater> getwater({required String uuid}) async {
    final waterreference =
        users.doc(_auth.currentUser!.uid).collection('water');
    final waterdoc = await waterreference.where(wuuid, isEqualTo: uuid).get();
    final waterdocid = waterdoc.docs.first.id;
    final value = await waterreference.doc(waterdocid).get();
    return DayWater(
        intakeml: value[wintakeml],
        outputml: value[woutputml],
        date: value[wdate],
        dayContents: _convertdaycontent(value[wdayContents]),
        uuid: uuid);
  }

  Future<NewWater> getwaterwithsubuuid(
      {required String uuid, required String subuuid}) async {
    final waterreference =
        users.doc(_auth.currentUser!.uid).collection('water');
    final waterdoc = await waterreference.where(wuuid, isEqualTo: uuid).get();
    final waterdocid = waterdoc.docs.first.id;
    final value = await waterreference.doc(waterdocid).get();
    final subcontents = value[wdayContents].firstWhere((e) {
      return e[wuuid] == subuuid;
    });

    return NewWater(
        value: subcontents[wvalue],
        type: subcontents[wtype] == 0
            ? Watertype.intake
            : subcontents[wtype] == 1
                ? Watertype.output
                : Watertype.misc,
        date: subcontents[wdate],
        time: subcontents[wtime],
        notes: subcontents[wnotes] ?? "",
        uuid: uuid);
  }

  Future<void> addWater(
      {required double intakeml,
      required double outputml,
      required double miscml,
      required String date,
      required String time,
      required String notes}) async {
    final waterreference =
        users.doc(_auth.currentUser!.uid).collection('water');
    final watersnapshot = await waterreference.get();
    final samedate = await waterreference.where(wdate, isEqualTo: date).get();
    if (watersnapshot.size == 0 || samedate.size == 0) {
      waterreference.add({
        wintakeml: intakeml + miscml,
        woutputml: outputml,
        wdate: date,
        wuuid: const Uuid().v4(),
        wdayContents: daycontentstolist(
            intakeml: intakeml,
            outputml: outputml,
            miscml: miscml,
            date: date,
            time: time,
            notes: notes),
      });
    } else {
      final docid = samedate.docs.first.id;
      final value = await waterreference.doc(docid).get();
      await waterreference.doc(docid).update({
        wintakeml: value[wintakeml] + intakeml + miscml,
        woutputml: value[woutputml] + outputml,
        wdayContents: FieldValue.arrayUnion(daycontentstolist(
            intakeml: intakeml,
            outputml: outputml,
            miscml: miscml,
            date: date,
            time: time,
            notes: notes))
      });
    }
  }

  Future<void> delete({required String uuid, required String subuuid}) async {
    final waterreference =
        users.doc(_auth.currentUser!.uid).collection('water');
    final sameuuid = await waterreference.where(wuuid, isEqualTo: uuid).get();
    final docid = sameuuid.docs.first.id;
    final doc = waterreference.doc(docid);
    final value = await doc.get();
    final daycontents = value[wdayContents];
    double newinput = value[wintakeml];
    double newoutput = value[woutputml];
    final newdaycontents = daycontents.where((e) {
      if (e[wuuid] == subuuid) {
        if (e[wtype] == 0 || e[wtype] == 2) {
          newinput = newinput - e[wvalue];
        } else {
          newoutput = newoutput - e[wvalue];
        }
      }
      return e[wuuid] != subuuid;
    }).toList();
    doc.update({
      wintakeml: newinput,
      woutputml: newoutput,
      wdayContents: newdaycontents
    });
  }

  Future<void> updatewater(
      {required double intakeml,
      required double outputml,
      required double miscml,
      required String date,
      required String time,
      required String notes,
      required String subuuid}) async {
    final waterreference =
        users.doc(_auth.currentUser!.uid).collection('water');

    final samedate = await waterreference.where(wdate, isEqualTo: date).get();
    if (samedate.size != 0) {
      final docid = samedate.docs.first.id;
      final docreference = waterreference.doc(docid);
      final value = await docreference.get();
      final daycontentsvalue = value[wdayContents];
      double newintakeml = value[wintakeml];
      double newoutputml = value[woutputml];
      final newdaycontents = daycontentsvalue.where((e) {
        if (e[wuuid] == subuuid) {
          if (e[wtype] == 0 || e[wtype] == 2) {
            newintakeml = newintakeml - e[wvalue];
          } else {
            newoutputml = newoutputml - e[wvalue];
          }
        }
        return e[wuuid] != subuuid;
      }).toList();
      newdaycontents.insertAll(
          0,
          daycontentstolist(
              intakeml: intakeml,
              outputml: outputml,
              miscml: miscml,
              date: date,
              time: time,
              notes: notes));
      docreference.update({
        wintakeml: newintakeml + intakeml + miscml,
        woutputml: newoutputml + outputml,
        wdayContents: newdaycontents,
      });
    }
  }

  List<Map> daycontentstolist(
      {required double intakeml,
      required double outputml,
      required double miscml,
      required String date,
      required String time,
      required String notes}) {
    List<Map> daycontents = [];
    if (intakeml != 0) {
      daycontents.add({
        wvalue: intakeml,
        wtype: 0,
        wdate: date,
        wtime: time,
        wnotes: notes,
        wuuid: const Uuid().v4()
      });
    }
    if (outputml != 0) {
      daycontents.add({
        wvalue: outputml,
        wtype: 1,
        wdate: date,
        wtime: time,
        wnotes: notes,
        wuuid: const Uuid().v4()
      });
    }
    if (miscml != 0) {
      daycontents.add({
        wvalue: miscml,
        wtype: 2,
        wdate: date,
        wtime: time,
        wnotes: notes,
        wuuid: const Uuid().v4()
      });
    }
    return daycontents;
  }

  List<DayWater> _listfromsnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DayWater(
          intakeml: doc.get(wintakeml),
          outputml: doc.get(woutputml),
          date: doc.get(wdate),
          dayContents: _convertdaycontent(doc.get(wdayContents)),
          uuid: doc.get(wuuid));
    }).toList();
  }

  Stream<List<DayWater>> get waters {
    return users
        .doc(_auth.currentUser!.uid)
        .collection('water')
        .snapshots()
        .map(_listfromsnapshots);
  }

  List<NewWater> _convertdaycontent(List daycontents) {
    return daycontents.map((element) {
      return NewWater(
          value: element[wvalue],
          type: element[wtype] == 0
              ? Watertype.intake
              : element[wtype] == 1
                  ? Watertype.output
                  : Watertype.misc,
          date: element[wdate],
          time: element[wtime],
          notes: element[wnotes] ?? "",
          uuid: element[wuuid]);
    }).toList();
  }
}
