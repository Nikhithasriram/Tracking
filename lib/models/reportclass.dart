import 'dart:typed_data';

import 'package:tracking_app/models/dialysisclass.dart';
import 'package:tracking_app/models/waterclass.dart';
import 'package:tracking_app/models/weightclass.dart';
import 'package:tracking_app/services/user.dart';

class ReportData{
  List<NewWeight> weightvalue;
  List<DayWater> waterIntakevalue;
  List<DayWater> waterOutputvalue;
  List<DialysisReading> dialysisvalue;
  Uint8List image;
  AppUser appuser;
  DateTime start;
  DateTime end;
  ReportData({
    required this.weightvalue,
    required this.waterIntakevalue,
    required this.waterOutputvalue,
    required this.dialysisvalue,
    required this.image,
    required this.appuser,
    required this.start,
    required this.end
  });
}