// import 'dart:collection';

// import 'package:flutter/material.dart';
// import 'package:tracking_app/functions/mydatetime.dart';
// import 'package:tracking_app/models/waterclass.dart';

// class WaterProvider extends ChangeNotifier {
//   final List<DayWater> _items = [];
//   int selected = -1;

//   UnmodifiableListView<DayWater> get items => UnmodifiableListView(_items);

//   void add(
//     double intakeml,
//     double outputml,
//     double miscml,
//     String date,
//     String time,
//     String notes,
//   ) {
//     bool added = false;
//     if (_items.isEmpty) {
//       _items.insert(
//           0, DayWater(intakeml: 0, outputml: 0, date: date, dayContents: []));
//       addingContentsAtIndex(intakeml, outputml, miscml, date, time, notes, 0);
//     } else {
//       for (int i = 0; i < _items.length; i++) {
//         if (date == _items[i].date) {
//           added = true;
//           addingContentsAtIndex(
//               intakeml, outputml, miscml, date, time, notes, i);
//           break;
//         }
//       }
//       if (added == false) {
//         for (int i = 0; i < _items.length; i++) {
//           // print(_items[i].date);
//           DateTime functiondatetime = mydatetime(date, time);
//           DateTime indexdatetime = mydatetime(_items[i].date, time);
//           if (functiondatetime.isAfter(indexdatetime) || functiondatetime == indexdatetime) {
//             added = true;
//             _items.insert(
//                 i,
//                 DayWater(
//                     intakeml: 0, outputml: 0, date: date, dayContents: []));
//             addingContentsAtIndex(
//                 intakeml, outputml, miscml, date, time, notes, i);
//             break;
//           }
//         }
//       }
//       if (added == false) {
//         _items.add(
//             DayWater(intakeml: 0, outputml: 0, date: date, dayContents: []));
//         addingContentsAtIndex(
//             intakeml, outputml, miscml, date, time, notes, _items.length - 1);
//       }
//     }

//     // print(_items[0]);
//     notifyListeners();
//   }

//   void addingContentsAtIndex(
//     double intakeml,
//     double outputml,
//     double miscml,
//     String date,
//     String time,
//     String notes,
//     int i,
//   ) {
//     if (intakeml != 0) {
//       addBasedOnTime(
//           NewWater(
//               value: intakeml,
//               type: Watertype.intake,
//               date: date,
//               time: time,
//               notes: notes),
//           i);
//     }
//     if (outputml != 0) {
//       addBasedOnTime(
//           NewWater(
//               value: outputml,
//               type: Watertype.output,
//               date: date,
//               time: time,
//               notes: notes),
//           i);
//     }
//     if (miscml != 0) {
//       addBasedOnTime(
//           NewWater(
//               value: miscml,
//               type: Watertype.misc,
//               date: date,
//               time: time,
//               notes: notes),
//           i);
//     }
//     _items[i].intakeml += intakeml + miscml;
//     _items[i].outputml += outputml;
//   }

//   void addBasedOnTime(NewWater w, int index) {
//     final contents = _items[index].dayContents;
//     DateTime funcdate = mydatetime(w.date, w.time);
//     bool added = false;
//     for (int i = 0; i < contents.length; i++) {
//       DateTime idate = mydatetime(contents[i].date, contents[i].time);
//       if (funcdate.isAfter(idate) || funcdate == idate) {
//         added = true;
//         _items[index].dayContents.insert(i, w);
//         break;
//       }
//     }
//     if (added == false) {
//       _items[index].dayContents.add(w);
//     }
//   }

//   void delete(int index, int dailycontentsindex) {
//     if (_items[index].dayContents[dailycontentsindex].type ==
//             Watertype.intake ||
//         _items[index].dayContents[dailycontentsindex].type == Watertype.misc) {
//       _items[index].intakeml = _items[index].intakeml -
//           _items[index].dayContents[dailycontentsindex].value;
//     } else {
//       _items[index].outputml = _items[index].outputml -
//           _items[index].dayContents[dailycontentsindex].value;
//     }
//     _items[index].dayContents.removeAt(dailycontentsindex);
//     notifyListeners();
//   }
// }
