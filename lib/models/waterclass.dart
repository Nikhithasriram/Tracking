import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:uuid/uuid.dart';

class NewWater {
  double value;
  Watertype type;
  String date;
  String time;
  String notes;
  String uuid;
  NewWater({
    required this.value,
    required this.type,
    required this.date,
    required this.time,
    required this.notes,
    required this.uuid,
    
  });
}

enum Watertype { intake, output, misc }

class DayWater {
  double intakeml;
  double outputml;
  String date;
  String uuid;
  List<NewWater> dayContents;
  Timestamp sortingtimestamp;
  DayWater(
      {required this.intakeml,
      required this.outputml,
      required this.date,
      required this.dayContents,
      required this.uuid,
      required this.sortingtimestamp,});
}
