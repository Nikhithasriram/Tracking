import 'package:uuid/uuid.dart';

class NewWeight {
  String uuid;
  double weight;
  String date;
  String time;
  String notes;
  NewWeight(
      {required this.weight,
      required this.date,
      required this.time,
      this.notes = ""})
      : uuid = const Uuid().v4();
}


