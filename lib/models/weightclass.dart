import 'package:cloud_firestore/cloud_firestore.dart';

class NewWeight {
  String uuid;
  double weight;
  String date;
  String time;
  String notes;
  Timestamp sortingtimestamp;
  NewWeight(
      {required this.weight,
      required this.date,
      required this.time,
      this.notes = "",
      required this.uuid,
      required this.sortingtimestamp});
}
