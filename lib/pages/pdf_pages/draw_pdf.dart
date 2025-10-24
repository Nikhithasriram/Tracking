import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:tracking_app/functions/mydatetime.dart';
import 'package:tracking_app/models/reportclass.dart';

Future<List<int>> drawPDF({required ReportData reportData}) async {
  PdfDocument document = PdfDocument();
  final page = document.pages.add();
  final PdfGraphics graphics = page.graphics;
  double marginLeft = 20;
  double yPosition = 100;
  final PdfPageTemplateElement pageHeader = PdfPageTemplateElement(
    Rect.fromLTRB(0, 0, document.pageSettings.size.width, 100),
  );

  // Draw the header text in the page template.
  pageHeader.graphics.drawString(
    "PD Report",
    PdfStandardFont(PdfFontFamily.helvetica, 40),
    bounds: Rect.fromLTWH(0, 20, document.pageSettings.size.width, 60),
  );

  // Assign the header to the page template.
  document.template.top = pageHeader;

  graphics.drawString(
    "Name: ${reportData.appuser.name}",
    PdfStandardFont(PdfFontFamily.helvetica, 13),
    bounds: Rect.fromLTWH(marginLeft, yPosition,
        document.pageSettings.size.width - marginLeft * 2, 20),
  );

  yPosition += 20; // Move down for the next line

  graphics.drawString(
    "Hospital: ${reportData.appuser.hospital}",
    PdfStandardFont(PdfFontFamily.helvetica, 13),
    bounds: Rect.fromLTWH(marginLeft, yPosition,
        document.pageSettings.size.width - marginLeft * 2, 20),
  );

  yPosition += 20; // Move down for the next line

  String date = reportData.appuser.dob != null
      ? DateFormat.yMMMd().format(reportData.appuser.dob!)
      : "";
  graphics.drawString(
    "Doctor: ${reportData.appuser.doctor}",
    PdfStandardFont(PdfFontFamily.helvetica, 13),
    bounds: Rect.fromLTWH(marginLeft, yPosition,
        document.pageSettings.size.width - marginLeft * 2, 20),
  );
  String gender = reportData.appuser.gender ?? " ";
  if (gender == "none"){
    gender = "Prefer Not to Say";
  }
  graphics.drawString("Gender: $gender",
      PdfStandardFont(PdfFontFamily.helvetica, 13),
      bounds: Rect.fromLTRB(document.pageSettings.width - 230, 100,
          document.pageSettings.width, 120));
  graphics.drawString(
      "DOB: $date", PdfStandardFont(PdfFontFamily.helvetica, 13),
      bounds: Rect.fromLTRB(document.pageSettings.width - 230, 120,
          document.pageSettings.width, 140));
  graphics.drawString(
      "Date Range: ${DateFormat.yMMMd().format(reportData.start)} - ${DateFormat.yMMMd().format(reportData.end)}",
      PdfStandardFont(PdfFontFamily.helvetica, 13),
      bounds: Rect.fromLTRB(marginLeft, 160, document.pageSettings.width, 180));

  // Draw a line below the header.
  pageHeader.graphics.drawLine(
    PdfPens.black,
    const Offset(0, 70),
    Offset(document.pageSettings.size.width, 70),
  );

  int count = 0;
  count = reportData.weightvalue.isNotEmpty ? count + 1 : count;
  count = reportData.waterIntakevalue.isNotEmpty ? count + 1 : count;
  count = reportData.waterOutputvalue.isNotEmpty ? count + 1 : count;
  //plus 2 for no of bags used
  count = reportData.dialysisvalue.isNotEmpty ? count + 2 : count;

  PdfGrid grid = PdfGrid();
  grid.style = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
      cellPadding: PdfPaddings(left: 2, right: 2, top: 2, bottom: 2));
  //plus 1 for date
  grid.columns.add(count: count + 1);
  grid.headers.add(1);

  PdfGridRow header = grid.headers[0];
  header.style = PdfGridCellStyle(
    font: PdfStandardFont(PdfFontFamily.helvetica, 13),
  );
  header.cells[0].value = "Date";
  int i = 1;
  List combination = [];
  Map combined = {};
  Map counter = {};
  // List<int> counter = [];
  DateTime latestdate = DateTime(1900);
  DateTime lastdate = DateTime(2500);

  if (reportData.weightvalue.isNotEmpty) {
    header.cells[i].value = "Weight";
    // weightvalue = weightvalue.reversed.toList();
    combination.add(reportData.weightvalue);
    combined.addAll({"weight": reportData.weightvalue});
    counter.addAll({"weight": reportData.weightvalue.length - 1});
    // counter.add(weightvalue.length - 1);
    DateTime date = mydatetime(
        reportData.weightvalue.last.date, reportData.weightvalue.last.time);
    if (date.isAfter(latestdate)) {
      latestdate = date;
    }
    date = mydatetime(
        reportData.weightvalue[0].date, reportData.weightvalue[0].time);
    if (date.isBefore(lastdate)) {
      lastdate = date;
    }
    i++;
  }
  if (reportData.waterIntakevalue.isNotEmpty) {
    header.cells[i].value = "Water Intake";
    // waterIntakeValue = waterIntakeValue.reversed.toList();
    combination.add(reportData.waterIntakevalue);
    combined.addAll({"waterIntake": reportData.waterIntakevalue});
    counter.addAll({"waterIntake": reportData.waterIntakevalue.length - 1});

    // counter.add(waterIntakeValue.length - 1);
    DateTime date =
        mydatetime(reportData.waterIntakevalue.last.date, "1:00 pm");
    if (date.isAfter(latestdate)) {
      latestdate = date;
    }
    date = mydatetime(reportData.waterIntakevalue[0].date, "1:00 pm");
    if (date.isBefore(lastdate)) {
      lastdate = date;
    }
    i++;
  }
  if (reportData.waterOutputvalue.isNotEmpty) {
    header.cells[i].value = "Water Output";
    // waterOutputValue = waterOutputValue.reversed.toList();

    combination.add(reportData.waterOutputvalue);
    // counter.add(waterOutputValue.length - 1);
    combined.addAll({"waterOutput": reportData.waterOutputvalue});
    counter.addAll({"waterOutput": reportData.waterOutputvalue.length - 1});

    DateTime date =
        mydatetime(reportData.waterOutputvalue.last.date, "1:00 pm");
    if (date.isAfter(latestdate)) {
      latestdate = date;
    }
    date = mydatetime(reportData.waterOutputvalue[0].date, "1:00 pm");
    if (date.isBefore(lastdate)) {
      lastdate = date;
    }
    i++;
  }
  if (reportData.dialysisvalue.isNotEmpty) {
    header.cells[i].value = "PD net Out";
    i++;
    header.cells[i].value = "No of Bags";
    // dialysisValue = dialysisValue.reversed.toList();
    combination.add(reportData.dialysisvalue);
    combined.addAll({"dialysis": reportData.dialysisvalue});
    counter.addAll({"dialysis": reportData.dialysisvalue.length - 1});

    // counter.add(dialysisValue.length - 1);
    DateTime date = mydatetime(reportData.dialysisvalue.last.date, "1:00 pm");
    if (date.isAfter(latestdate)) {
      latestdate = date;
    }
    date = mydatetime(reportData.dialysisvalue[0].date, "1:00 pm");
    if (date.isBefore(lastdate)) {
      lastdate = date;
    }
  }

  DateTime idate = latestdate;
  // print(lastdate.toString());
  // print(latestdate.toString());

  while (idate.isAfter(lastdate) ||
      (idate.year == lastdate.year &&
          idate.month == lastdate.month &&
          idate.day == lastdate.day)) {
    int pos = 0;

    List<String> defaultrow;
    if (reportData.dialysisvalue.isNotEmpty) {
      //plus two is one for the date and another one is for the no of bags
      defaultrow = List.filled(combined.length + 2, "");
    } else {
      //plus one is for the date
      defaultrow = List.filled(combined.length + 1, "");
    }
    // PdfGridRow row = grid.rows.add();
    for (var e in combined.entries) {
      pos++;
      if (counter[e.key] >= 0) {
        DateTime valuedate =
            mydatetime(e.value[counter[e.key]].date, "1:00 pm");
        // bool added = false;

        if (valuedate.year == idate.year &&
            valuedate.month == idate.month &&
            valuedate.day == idate.day) {
          defaultrow[0] = DateFormat.yMMMd().format(idate);

          if (e.key == "weight") {
            String weight = e.value[counter[e.key]].weight.toString();
            --counter[e.key];
            while (counter[e.key] > 0) {
              if (mydatetime(e.value[counter[e.key]].date, "1:00 pm")
                  .isAtSameMomentAs(mydatetime(
                      e.value[counter[e.key] + 1].date, "1:00 pm"))) {
                weight =
                    "$weight \n${e.value[counter[e.key] - 1].weight.toString()}";
                // defaultrow[pos] =
                //     '${e.value[counter[e.key]].weight.toString()}\n${e.value[counter[e.key] - 1].weight.toString()}';
                counter[e.key]--;
              } else {
                break;
              }
            }
            defaultrow[pos] = weight;
          }
          if (e.key == "waterIntake") {
            defaultrow[pos] = e.value[counter[e.key]].intakeml.toString();

            counter[e.key]--;
          }
          if (e.key == "waterOutput") {
            defaultrow[pos] = e.value[counter[e.key]].outputml.toString();
            counter[e.key]--;
          }
          if (e.key == "dialysis") {
            defaultrow[pos] = e.value[counter[e.key]].netml.toString();
            pos++;
            defaultrow[pos] =
                ((e.value[counter[e.key]].session.length) - 1).toString();

            counter[e.key]--;
          }
        }
      }
    }

    if (!defaultrow.every((e) => e == "")) {
      PdfGridRow row = grid.rows.add();

      for (int i = 0; i < defaultrow.length; i++) {
        row.cells[i].value = defaultrow[i];
      }
    }

    idate = DateTime(idate.year, idate.month, idate.day - 1);
  }
  // print(ele);

  grid.draw(page: page, bounds: const Rect.fromLTRB(5, 200, 5, 0));

  final PdfBitmap bitmap = PdfBitmap(reportData.image);
  final double height = bitmap.height.toDouble();
  final double width = bitmap.width.toDouble();
  final double newheight = height * 0.4;
  final double newwidth = newheight * width / height;
  double initialleft;
  if (combined.length == 4) {
    initialleft = 70;
  } else if (combined.length == 3) {
    initialleft = 100;
  } else if (combined.length == 2) {
    initialleft = 140;
  } else {
    initialleft = 200;
  }
  final page2 = document.pages.add();
  if (reportData.weightvalue.isNotEmpty) {
    page2.graphics.drawString(
      "Weight",
      PdfStandardFont(PdfFontFamily.helvetica, 15),
      bounds: Rect.fromLTRB(initialleft, 40, initialleft + 50, 70),
    );
    page2.graphics.drawRectangle(
        bounds: Rect.fromLTRB(initialleft + 55, 45, initialleft + 65, 55),
        brush: PdfSolidBrush(PdfColor(76, 175, 80)));
    initialleft = initialleft + 80;
  }

  if (reportData.waterIntakevalue.isNotEmpty) {
    page2.graphics.drawString(
      "Water Intake",
      PdfStandardFont(PdfFontFamily.helvetica, 15),
      bounds: Rect.fromLTRB(initialleft, 40, initialleft + 90, 70),
    );
    page2.graphics.drawRectangle(
        bounds: Rect.fromLTRB(initialleft + 90, 45, initialleft + 100, 55),
        brush: PdfSolidBrush(PdfColor(33, 150, 243)));
    initialleft = initialleft + 115;
  }
  if (reportData.waterOutputvalue.isNotEmpty) {
    page2.graphics.drawString(
      "Water Output",
      PdfStandardFont(PdfFontFamily.helvetica, 15),
      bounds: Rect.fromLTRB(initialleft, 40, initialleft + 95, 70),
    );
    page2.graphics.drawRectangle(
        bounds: Rect.fromLTRB(initialleft + 95, 45, initialleft + 105, 55),
        brush: PdfSolidBrush(PdfColor(255, 193, 7)));
    initialleft = initialleft + 120;
  }
  if (reportData.dialysisvalue.isNotEmpty) {
    page2.graphics.drawString(
      "PD Out",
      PdfStandardFont(PdfFontFamily.helvetica, 15),
      bounds: Rect.fromLTRB(initialleft, 40, initialleft + 55, 70),
    );
    page2.graphics.drawRectangle(
        bounds: Rect.fromLTRB(initialleft + 55, 45, initialleft + 65, 55),
        brush: PdfSolidBrush(PdfColor(156, 39, 176)));
    initialleft = initialleft + 75;
  }
  page2.graphics
      .drawString("PD Trend", PdfStandardFont(PdfFontFamily.helvetica, 20));
  page2.graphics
      .drawImage(bitmap, Rect.fromLTRB(50, 60, newwidth + 50, newheight + 30));

  List<int> bytes = await document.save();
  document.dispose();
  return bytes;
  // saveandlanchFile(bytes, 'report.pdf');
}
