// import 'dart:collection';
// import 'package:tracking_app/models/weightclass.dart';
// import 'package:flutter/material.dart';
// import 'package:tracking_app/functions/mydatetime.dart';

// class WeightProvider extends ChangeNotifier {
//   final List<NewWeight> _item = [];
//   UnmodifiableListView<NewWeight> get items => UnmodifiableListView(_item);

//   void add(NewWeight w) {
//     if (_item.isEmpty) {
//       _item.add(w);
//       notifyListeners();
//     } else {
//       bool added = false;
//       DateTime weightdate = mydatetime(w.date, w.time);
//       for (int i = 0; i < _item.length; i++) {
//         DateTime idate = mydatetime(_item[i].date , _item[i].time);
//         if (weightdate.isAfter(idate)) {
//           _item.insert(i, w);
//           notifyListeners();
//           added = true;
//           break;
//         }
//       }
//       if (added == false) {
//         _item.add(w);
//         notifyListeners();
//       }
//     }
//   }

//   void delete(NewWeight w) {
//     _item.remove(w);
//     notifyListeners();
//   }

//   void update(int index, NewWeight w) {
//     delete(_item[index]);
//     add(w);
//     notifyListeners();
//   }
// }


