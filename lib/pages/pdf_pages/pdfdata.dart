import 'dart:typed_data';

import 'package:tracking_app/models/dialysisclass.dart';
import 'package:tracking_app/models/graphselection.dart';
import 'package:tracking_app/models/waterclass.dart';
import 'package:tracking_app/models/weightclass.dart';
import 'package:tracking_app/pages/pdf_pages/create_pdf.dart';
import 'package:tracking_app/services/database_dialysis.dart';
import 'package:tracking_app/services/database_water.dart';
import 'package:tracking_app/services/database_weight.dart';
import 'package:tracking_app/services/user.dart';

Future<void> pdfdata(
    {required Selected option,
    required Set<Graphtype> graphveiw,
    required Uint8List image,
    DateTime? startdate,
    DateTime? enddate}) async {
  List<NewWeight> weightvalue = [];
  List<DayWater> waterIntakeValue = [];
  List<DayWater> waterOutputValue = [];
  List<DialysisReading> dialysisValue = [];
  AppUser appUser = await User().appUserinfo();
  DateTime start  = getdate(option);
  // DateTime end;

  DateTime end = DateTime.now();
  if (startdate == null && enddate == null) {
    if (graphveiw.contains(Graphtype.weight)) {
      start = getdate(option);
      weightvalue = await DatabaseWeights().weightBetweenDates(start, end);
    }
    if (graphveiw.contains(Graphtype.waterIntake)) {
      start = getdate(option);

      waterIntakeValue = await DatabaseWater().waterBetweenDates(start, end);
    }
    if (graphveiw.contains(Graphtype.waterOutput)) {
      start = getdate(option);

      waterOutputValue =
          await DatabaseWater().waterBetweenDates(getdate(option), end);
    }
    if (graphveiw.contains(Graphtype.dialysisOut)) {
      start = getdate(option);

      dialysisValue = await DatabaseDialysis()
          .dialysisReadingBetweenDates(getdate(option), end);
    }
  }
  else if (startdate != null && enddate != null) {
    start = startdate;
    end = enddate;
    if (graphveiw.contains(Graphtype.weight)) {
      weightvalue =
          await DatabaseWeights().weightBetweenDates(startdate, enddate);
    }
    if (graphveiw.contains(Graphtype.waterIntake)) {
      waterIntakeValue =
          await DatabaseWater().waterBetweenDates(startdate, enddate);
    }
    if (graphveiw.contains(Graphtype.waterOutput)) {
      waterOutputValue =
          await DatabaseWater().waterBetweenDates(startdate, enddate);
    }
    if (graphveiw.contains(Graphtype.dialysisOut)) {
      dialysisValue = await DatabaseDialysis()
          .dialysisReadingBetweenDates(startdate, enddate);
    }
  }

  createPDF(
      weightvalue: weightvalue,
      waterIntakeValue: waterIntakeValue,
      waterOutputValue: waterOutputValue,
      dialysisValue: dialysisValue,
      image: image,
      appuser: appUser , start: start , end: end);
}

DateTime getdate(Selected option) {
  DateTime end = DateTime.now();
  if (option == Selected.month) {
    return DateTime(end.year, end.month - 1, end.day, end.hour);
  } else if (option == Selected.threemonths) {
    // print("3months");
    return DateTime(end.year, end.month - 3, end.day, end.hour);
  } else if (option == Selected.year) {
    return DateTime(end.year - 1, end.month, end.day, end.hour);
  } else {
    return DateTime.now();
  }
}
