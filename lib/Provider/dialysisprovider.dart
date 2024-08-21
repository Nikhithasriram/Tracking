// import 'dart:collection';

// import 'package:flutter/material.dart';
// import 'package:tracking_app/functions/mydatetime.dart';
// import 'package:tracking_app/models/dialysis.dart';

// class DialysisProvier extends ChangeNotifier {
//   final List<DialysisReading> _items = [];
//   UnmodifiableListView get items => UnmodifiableListView(_items);

//   void add(Onesession reading) {
//     DateTime sessiondate = mydatetime(reading.date, "5:00 am");
//     bool added = false;
//     for (int i = 0; i < _items.length; i++) {
//       DateTime loopdate = mydatetime(_items[i].date, "5:00 am");
//       if (sessiondate == loopdate) {
//         added = true;
//         addContentsfromindex(index: i, reading: reading);
//         break;
//       }
//     }
//     if (added == false) {
//       for (int i = 0; i < _items.length; i++) {
//         DateTime loopdate = mydatetime(_items[i].date, "5:00 am");
//         if (sessiondate.isAfter(loopdate)) {
//           added = true;
//           _items.insert(
//               i, DialysisReading(netml: 0, date: reading.date, session: []));
//           addContentsfromindex(index: i, reading: reading);
//           break;
//         }
//       }
//     }
//     if (added == false) {
//       _items.add(DialysisReading(netml: 0, date: reading.date, session: []));
//       addContentsfromindex(index: _items.length - 1, reading: reading);
//     }

//     notifyListeners();
//   }

//   void addContentsfromindex({required int index, required Onesession reading}) {
//     DateTime readingdatetime = mydatetime(reading.date, reading.time);
//     bool added = false;
//     for (int i = _items[index].session.length - 1; i >= 0; i--) {
//       DateTime loopdatetime = mydatetime(
//           _items[index].session[i].date, _items[index].session[i].time);
//       if (readingdatetime.isAfter(loopdatetime) ||
//           readingdatetime == loopdatetime) {
//         added = true;
//         double sessionnet = reading.outml - _items[index].session[i].inml;
//         if (i == _items[index].session.length - 1) {
//           _items[index].session.add(Onesession(
//               inml: reading.inml,
//               outml: reading.outml,
//               date: reading.date,
//               time: reading.time,
//               sessionnet: sessionnet,
//               notes: reading.notes));
//           _items[index].netml += sessionnet;
//         } else {
//           _items[index].session.insert(
//               i + 1,
//               Onesession(
//                   inml: reading.inml,
//                   outml: reading.outml,
//                   date: reading.date,
//                   time: reading.time,
//                   sessionnet: sessionnet,
//                   notes: reading.notes));
//           _items[index].netml += sessionnet;
//         }

//         break;
//       }
//     }
//     if (added == false) {
//       if (_items[index].session.isEmpty) {
//         _items[index].session.add(Onesession(
//             inml: reading.inml,
//             outml: reading.outml,
//             date: reading.date,
//             time: reading.time,
//             sessionnet: 0,
//             notes: reading.notes));
//         _items[index].netml += 0;
//       } else {
//         double sessionnet = reading.outml - _items[index].session[-2].inml;
//         _items[index].session.add(Onesession(
//             inml: reading.inml,
//             outml: reading.outml,
//             date: reading.date,
//             time: reading.time,
//             sessionnet: sessionnet,
//             notes: reading.notes));
//         _items[index].netml += sessionnet;
//       }
//     }
//   }

//   void delete({required int index, required int subindex}) {
//     items[index].session.removeAt(subindex);
//     notifyListeners();
//   }
// }
