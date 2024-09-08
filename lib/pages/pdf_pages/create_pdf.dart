import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:tracking_app/functions/mydatetime.dart';
import 'package:tracking_app/models/dialysisclass.dart';
import 'package:tracking_app/models/waterclass.dart';
import 'package:tracking_app/models/weightclass.dart';
import 'package:tracking_app/pages/pdf_pages/preview_pdf.dart';
import 'package:tracking_app/services/user.dart';

Future<void> createPDF(
    {required List<NewWeight> weightvalue,
    required List<DayWater> waterIntakeValue,
    required List<DayWater> waterOutputValue,
    required List<DialysisReading> dialysisValue,
    required Uint8List image,
    required AppUser appuser,
    required DateTime start,
    required DateTime end}) async {
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
    "Name: ${appuser.name}",
    PdfStandardFont(PdfFontFamily.helvetica, 13),
    bounds: Rect.fromLTWH(marginLeft, yPosition,
        document.pageSettings.size.width - marginLeft * 2, 20),
  );

  yPosition += 20; // Move down for the next line

  graphics.drawString(
    "Gender: ${appuser.gender}",
    PdfStandardFont(PdfFontFamily.helvetica, 13),
    bounds: Rect.fromLTWH(marginLeft, yPosition,
        document.pageSettings.size.width - marginLeft * 2, 20),
  );

  yPosition += 20; // Move down for the next line

  String date =
      appuser.dob != null ? DateFormat.yMMMd().format(appuser.dob!) : "";
  graphics.drawString(
    "DOB: $date",
    PdfStandardFont(PdfFontFamily.helvetica, 13),
    bounds: Rect.fromLTWH(marginLeft, yPosition,
        document.pageSettings.size.width - marginLeft * 2, 20),
  );

  graphics.drawString("Hospital: ${appuser.hospital}",
      PdfStandardFont(PdfFontFamily.helvetica, 13),
      bounds: Rect.fromLTRB(document.pageSettings.width - 230, 100,
          document.pageSettings.width, 120));
  graphics.drawString(
      "Doctor: ${appuser.doctor}", PdfStandardFont(PdfFontFamily.helvetica, 13),
      bounds: Rect.fromLTRB(document.pageSettings.width - 230, 120,
          document.pageSettings.width, 140));
  graphics.drawString(
      "Date Range: ${DateFormat.yMMMd().format(start)} - ${DateFormat.yMMMd().format(end)}",
      PdfStandardFont(PdfFontFamily.helvetica, 13),
      bounds: Rect.fromLTRB(marginLeft, 160, document.pageSettings.width, 180));

  // Draw a line below the header.
  pageHeader.graphics.drawLine(
    PdfPens.black,
    const Offset(0, 70),
    Offset(document.pageSettings.size.width, 70),
  );

  int count = 0;
  count = weightvalue.isNotEmpty ? count + 1 : count;
  count = waterIntakeValue.isNotEmpty ? count + 1 : count;
  count = waterOutputValue.isNotEmpty ? count + 1 : count;
  //plus 2 for no of bags used
  count = dialysisValue.isNotEmpty ? count + 2 : count;

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

  if (weightvalue.isNotEmpty) {
    header.cells[i].value = "Weight";
    // weightvalue = weightvalue.reversed.toList();
    combination.add(weightvalue);
    combined.addAll({"weight": weightvalue});
    counter.addAll({"weight": weightvalue.length - 1});
    // counter.add(weightvalue.length - 1);
    DateTime date = mydatetime(weightvalue.last.date, weightvalue.last.time);
    if (date.isAfter(latestdate)) {
      latestdate = date;
    }
    date = mydatetime(weightvalue[0].date, weightvalue[0].time);
    if (date.isBefore(lastdate)) {
      lastdate = date;
    }
    i++;
  }
  if (waterIntakeValue.isNotEmpty) {
    header.cells[i].value = "Water Intake";
    // waterIntakeValue = waterIntakeValue.reversed.toList();
    combination.add(waterIntakeValue);
    combined.addAll({"waterIntake": waterIntakeValue});
    counter.addAll({"waterIntake": waterIntakeValue.length - 1});

    // counter.add(waterIntakeValue.length - 1);
    DateTime date = mydatetime(waterIntakeValue.last.date, "1:00 pm");
    if (date.isAfter(latestdate)) {
      latestdate = date;
    }
    date = mydatetime(waterIntakeValue[0].date, "1:00 pm");
    if (date.isBefore(lastdate)) {
      lastdate = date;
    }
    i++;
  }
  if (waterOutputValue.isNotEmpty) {
    header.cells[i].value = "Water Output";
    // waterOutputValue = waterOutputValue.reversed.toList();

    combination.add(waterOutputValue);
    // counter.add(waterOutputValue.length - 1);
    combined.addAll({"waterOutput": waterOutputValue});
    counter.addAll({"waterOutput": waterOutputValue.length - 1});

    DateTime date = mydatetime(waterOutputValue.last.date, "1:00 pm");
    if (date.isAfter(latestdate)) {
      latestdate = date;
    }
    date = mydatetime(waterOutputValue[0].date, "1:00 pm");
    if (date.isBefore(lastdate)) {
      lastdate = date;
    }
    i++;
  }
  if (dialysisValue.isNotEmpty) {
    header.cells[i].value = "PD net Out";
    i++;
    header.cells[i].value = "No of Bags";
    // dialysisValue = dialysisValue.reversed.toList();
    combination.add(dialysisValue);
    combined.addAll({"dialysis": dialysisValue});
    counter.addAll({"dialysis": dialysisValue.length - 1});

    // counter.add(dialysisValue.length - 1);
    DateTime date = mydatetime(dialysisValue.last.date, "1:00 pm");
    if (date.isAfter(latestdate)) {
      latestdate = date;
    }
    date = mydatetime(dialysisValue[0].date, "1:00 pm");
    if (date.isBefore(lastdate)) {
      lastdate = date;
    }
  }

  DateTime idate = latestdate;
  // print(lastdate.toString());
  // print(latestdate.toString());

  while (idate.isAfter(lastdate)) {
    int pos = 0;

    List<String> defaultrow;
    if (dialysisValue.isNotEmpty) {
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
            if (counter[e.key] != 0) {
              if (mydatetime(e.value[counter[e.key]].date, "1:00 pm")
                  .isAtSameMomentAs(mydatetime(
                      e.value[counter[e.key] - 1].date, "1:00 pm"))) {
                defaultrow[pos] =
                    '${e.value[counter[e.key]].weight.toString()}\n${e.value[counter[e.key] - 1].weight.toString()}';
                counter[e.key] = counter[e.key] - 2;

                continue;
              }
            }
            defaultrow[pos] = e.value[counter[e.key]].weight.toString();
            counter[e.key]--;
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

  final PdfBitmap bitmap = PdfBitmap(image);
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
  if (weightvalue.isNotEmpty) {
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

  if (waterIntakeValue.isNotEmpty) {
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
  if (waterOutputValue.isNotEmpty) {
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
  if (dialysisValue.isNotEmpty) {
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
  saveandlanchFile(bytes, 'report.pdf');
}
