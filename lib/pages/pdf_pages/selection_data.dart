import 'dart:typed_data';

import 'package:tracking_app/models/graphselection.dart';
import 'package:tracking_app/pages/pdf_pages/pdfdata.dart';

Future<void> selectionData(Selected option, DateTime start, DateTime end,
    Set<Graphtype> graphveiw , Uint8List image) async {
  switch (option) {
    case Selected.month:
      await pdfdata(
        option: Selected.month,
        graphveiw: graphveiw,
        image: image
      );
    case Selected.threemonths:
      await pdfdata(
        option: Selected.threemonths,
        graphveiw: graphveiw,
        image: image
      );
    case Selected.year:
      await pdfdata(
        option: Selected.year,
        graphveiw: graphveiw,
        image: image
      );
    case Selected.custom:
      await pdfdata(
        option: Selected.custom,
        graphveiw: graphveiw,
        startdate: start,
        enddate: end,
        image: image
      );
  }
}
