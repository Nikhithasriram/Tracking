import 'package:cloud_firestore/cloud_firestore.dart';

class DialysisReading {
  double netml;
  String date;
  List<Onesession> session;
  String uuid;
  Timestamp sortingtimestamp;

  DialysisReading(
      {required this.netml,
      required this.date,
      required this.session,
      required this.uuid,
      required this.sortingtimestamp});
}

class Onesession {
  double inml;
  double outml;
  double sessionnet;
  String date;
  String time;
  String notes;
  String uuid;

  Onesession(
      {required this.inml,
      required this.outml,
      required this.date,
      required this.time,
      required this.sessionnet,
      required this.notes,
      required this.uuid});
}
