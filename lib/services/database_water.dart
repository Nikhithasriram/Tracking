import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracking_app/functions/mydatetime.dart';
import 'package:tracking_app/models/waterclass.dart';
import 'package:uuid/uuid.dart';

class DatabaseWater {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final String _value = "value";
  final String _time = "time";
  final String _date = "date";
  final String _notes = "notes";
  final String _dayContents = "dayContents";
  final String _uuid = "uuid";
  final String _intakeml = "intakeml";
  final String _outputml = "outputml";
  final String _type = "_type";
  final String _sortingtime = "sortingtimestamp";

  Future<DayWater> getwater({required String uuid}) async {
    final waterreference =
        users.doc(_auth.currentUser!.uid).collection('water');
    final waterdoc = await waterreference.where(_uuid, isEqualTo: uuid).get();
    final waterdocid = waterdoc.docs.first.id;
    final value = await waterreference.doc(waterdocid).get();
    return DayWater(
        intakeml: value[_intakeml],
        outputml: value[_outputml],
        date: value[_date],
        dayContents: _convertdaycontent(value[_dayContents]),
        uuid: uuid,
        sortingtimestamp:
            Timestamp.fromDate(mydatetime(value[_date], "1:00 pm")));
  }

  Future<List<DayWater>> waterBetweenDates(DateTime start, DateTime end) async {
    final betweendatesdocs = await users
        .doc(_auth.currentUser!.uid)
        .collection('water')
        .where(_sortingtime, isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where(_sortingtime, isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy(
          _sortingtime,
        )
        .get();
    return _listfromsnapshots(betweendatesdocs);
  }

  Future<NewWater> getwaterwithsubuuid(
      {required String uuid, required String subuuid}) async {
    final waterreference =
        users.doc(_auth.currentUser!.uid).collection('water');
    final waterdoc = await waterreference.where(_uuid, isEqualTo: uuid).get();
    final waterdocid = waterdoc.docs.first.id;
    final value = await waterreference.doc(waterdocid).get();
    final subcontents = value[_dayContents].firstWhere((e) {
      return e[_uuid] == subuuid;
    });

    return NewWater(
      value: subcontents[_value],
      type: subcontents[_type] == 0
          ? Watertype.intake
          : subcontents[_type] == 1
              ? Watertype.output
              : Watertype.misc,
      date: subcontents[_date],
      time: subcontents[_time],
      notes: subcontents[_notes] ?? "",
      uuid: uuid,
    );
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
    final samedate = await waterreference.where(_date, isEqualTo: date).get();
    if (watersnapshot.size == 0 || samedate.size == 0) {
      waterreference.add({
        _intakeml: intakeml + miscml,
        _outputml: outputml,
        _date: date,
        _uuid: const Uuid().v4(),
        _sortingtime: Timestamp.fromDate(mydatetime(date, "1:00 pm")),
        _dayContents: daycontentstolist(
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
      final List<NewWater> daycontents =
          _convertdaycontent(value.get(_dayContents));
      final newdaycontents = _addaccordingtotime(
          daycontents, intakeml, outputml, miscml, date, time, notes);
      await waterreference.doc(docid).update({
        _intakeml: value[_intakeml] + intakeml + miscml,
        _outputml: value[_outputml] + outputml,
        _dayContents: _convertToMap(newdaycontents)
      });
    }
  }

  List<NewWater> _addaccordingtotime(
    List<NewWater> daycontents,
    double intakeml,
    double outputml,
    double miscml,
    String date,
    String time,
    String notes,
  ) {
    if (intakeml != 0) {
      daycontents = _basedOnTime(
        daycontents,
        NewWater(
            value: intakeml,
            type: Watertype.intake,
            date: date,
            time: time,
            notes: notes,
            uuid: const Uuid().v4()),
      );
    }
    if (outputml != 0) {
      daycontents = _basedOnTime(
        daycontents,
        NewWater(
            value: outputml,
            type: Watertype.output,
            date: date,
            time: time,
            notes: notes,
            uuid: const Uuid().v4()),
      );
    }
    if (miscml != 0) {
      daycontents = _basedOnTime(
        daycontents,
        NewWater(
            value: miscml,
            type: Watertype.misc,
            date: date,
            time: time,
            notes: notes,
            uuid: const Uuid().v4()),
      );
    }
    return daycontents;
  }

  List<NewWater> _basedOnTime(List<NewWater> daycontents, NewWater value) {
    bool added = false;
    DateTime readingdate = mydatetime(value.date, value.time);
    if (readingdate
        .isBefore(mydatetime(daycontents[0].date, daycontents[0].time))) {
      daycontents.insert(0, value);
      added = true;
    }
    if (added == false) {
      for (int i = 0; i < daycontents.length - 1; i++) {
        DateTime loopdate =
            mydatetime(daycontents[i].date, daycontents[i].time);
        DateTime nextloopdate =
            mydatetime(daycontents[i + 1].date, daycontents[i + 1].time);
        if (readingdate.isAfter(loopdate) &&
            readingdate.isBefore(nextloopdate)) {
          added = true;
          daycontents.insert(i + 1, value);
        }
      }
    }
    if (added == false && daycontents.length == 1) {
      if (readingdate
          .isAfter(mydatetime(daycontents[0].date, daycontents[0].time))) {
        daycontents.add(value);
      } else {
        daycontents.insert(0, value);
      }
      added = true;
    }
    if (added == false) {
      daycontents.add(value);
    }
    return daycontents;
  }

  List<Map> _convertToMap(List<NewWater> daycontents) {
    List<Map> mapcontents = [];
    for (int i = 0; i < daycontents.length; i++) {
      if (daycontents[i].type == Watertype.intake) {
        mapcontents.add({
          _value: daycontents[i].value,
          _type: 0,
          _date: daycontents[i].date,
          _time: daycontents[i].time,
          _notes: daycontents[i].notes,
          _uuid: const Uuid().v4()
        });
      } else if (daycontents[i].type == Watertype.output) {
        mapcontents.add({
          _value: daycontents[i].value,
          _type: 1,
          _date: daycontents[i].date,
          _time: daycontents[i].time,
          _notes: daycontents[i].notes,
          _uuid: const Uuid().v4()
        });
      }
      if (daycontents[i].type == Watertype.misc) {
        mapcontents.add({
          _value: daycontents[i].value,
          _type: 2,
          _date: daycontents[i].date,
          _time: daycontents[i].time,
          _notes: daycontents[i].notes,
          _uuid: const Uuid().v4()
        });
      }
    }
    return mapcontents;
  }

  Future<void> delete({required String uuid, required String subuuid}) async {
    final waterreference =
        users.doc(_auth.currentUser!.uid).collection('water');
    final sameuuid = await waterreference.where(_uuid, isEqualTo: uuid).get();
    final docid = sameuuid.docs.first.id;
    final doc = waterreference.doc(docid);
    final value = await doc.get();
    final daycontents = value[_dayContents];
    double newinput = value[_intakeml];
    double newoutput = value[_outputml];
    final newdaycontents = daycontents.where((e) {
      if (e[_uuid] == subuuid) {
        if (e[_type] == 0 || e[_type] == 2) {
          newinput = newinput - e[_value];
        } else {
          newoutput = newoutput - e[_value];
        }
      }
      return e[_uuid] != subuuid;
    }).toList();
    if (newdaycontents.length > 0) {
      doc.update({
        _intakeml: newinput,
        _outputml: newoutput,
        _dayContents: newdaycontents
      });
    } else {
      doc.delete();
    }
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

    final samedate = await waterreference.where(_date, isEqualTo: date).get();
    if (samedate.size != 0) {
      final docid = samedate.docs.first.id;
      final docreference = waterreference.doc(docid);
      final value = await docreference.get();
      final List<NewWater> daycontentsvalue =
          _convertdaycontent(value[_dayContents]);
      double newintakeml = value[_intakeml];
      double newoutputml = value[_outputml];
      final List<NewWater> deleteddaycontents = daycontentsvalue.where((e) {
        if (e.uuid == subuuid) {
          if (e.type == Watertype.intake || e.type == Watertype.misc) {
            newintakeml = newintakeml - e.value;
          } else {
            newoutputml = newoutputml - e.value;
          }
        }
        return e.uuid != subuuid;
      }).toList();
      final List<NewWater> addeddaycontents = _addaccordingtotime(
          deleteddaycontents, intakeml, outputml, miscml, date, time, notes);
      docreference.update({
        _intakeml: newintakeml + intakeml + miscml,
        _outputml: newoutputml + outputml,
        _dayContents: _convertToMap(addeddaycontents),
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
        _value: intakeml,
        _type: 0,
        _date: date,
        _time: time,
        _notes: notes,
        _uuid: const Uuid().v4()
      });
    }
    if (outputml != 0) {
      daycontents.add({
        _value: outputml,
        _type: 1,
        _date: date,
        _time: time,
        _notes: notes,
        _uuid: const Uuid().v4()
      });
    }
    if (miscml != 0) {
      daycontents.add({
        _value: miscml,
        _type: 2,
        _date: date,
        _time: time,
        _notes: notes,
        _uuid: const Uuid().v4()
      });
    }
    return daycontents;
  }

  List<DayWater> _listfromsnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DayWater(
          intakeml: doc.get(_intakeml),
          outputml: doc.get(_outputml),
          date: doc.get(_date),
          dayContents: _convertdaycontent(doc.get(_dayContents)),
          uuid: doc.get(_uuid),
          sortingtimestamp: doc.get(_sortingtime));
    }).toList();
  }

  Stream<List<DayWater>> get waters {
    return users
        .doc(_auth.currentUser!.uid)
        .collection('water')
        .orderBy(_sortingtime, descending: true)
        .snapshots()
        .map(_listfromsnapshots);
  }

  List<NewWater> _convertdaycontent(List daycontents) {
    return daycontents.map((element) {
      return NewWater(
        value: element[_value],
        type: element[_type] == 0
            ? Watertype.intake
            : element[_type] == 1
                ? Watertype.output
                : Watertype.misc,
        date: element[_date],
        time: element[_time],
        notes: element[_notes] ?? "",
        uuid: element[_uuid],
      );
    }).toList();
  }
}
