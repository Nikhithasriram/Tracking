class DialysisReading {
  double netml;
  String date;
  List<Onesession> session;

  DialysisReading(
      {required this.netml, required this.date, required this.session});
}

class Onesession {
  double inml;
  double outml;
  double sessionnet;
  String date;
  String time;
  String notes;

  Onesession(
      {required this.inml,
      required this.outml,
      required this.date,
      required this.time,
      required this.sessionnet , 
      required this.notes});
}
