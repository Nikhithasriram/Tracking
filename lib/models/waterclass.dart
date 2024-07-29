import 'package:uuid/uuid.dart';

class NewWater {
  double value;
  Watertype type;
  String date;
  String time;
  String notes;
  NewWater({
    required this.value,
    required this.type,
    required this.date,
    required this.time,
    required this.notes,
  });
}

enum Watertype { intake, output, misc }

class DayWater {
  double intakeml;
  double outputml;
  String date;
  String uuid;
  List<NewWater> dayContents;

  DayWater({
    required this.intakeml,
    required this.outputml,
    required this.date,
    required this.dayContents,
  }) : uuid = const Uuid().v4();
}
