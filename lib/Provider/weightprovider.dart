import 'dart:collection';
import 'package:tracking_app/models/weightclass.dart';
import 'package:flutter/material.dart';

class WeightProvider extends ChangeNotifier {
  final List<NewWeight> _item = [];
  UnmodifiableListView<NewWeight> get items => UnmodifiableListView(_item);

  void add(NewWeight w) {
    if (_item.isEmpty) {
      _item.add(w);
      notifyListeners();
    } else {
      bool added = false;
      DateTime weightdate = mydatetime(w);
      for (int i = 0; i < _item.length; i++) {
        DateTime idate = mydatetime(_item[i]);
        if (weightdate.isAfter(idate)) {
          _item.insert(i, w);
          notifyListeners();
          added = true;
          break;
        }
      }
      if (added == false) {
        _item.add(w);
        notifyListeners();
      }
    }
  }

  void delete(NewWeight w) {
    _item.remove(w);
    notifyListeners();
  }

  void update(int index, NewWeight w) {
    delete(_item[index]);
    add(w);
    notifyListeners();
  }
}

DateTime mydatetime(NewWeight w) {
  String date = w.date.split('-')[0];
  String month = w.date.split('-')[1];
  String year = w.date.split('-')[2];
  date = int.parse(date) < 10 ? "0$date" : date;
  month = int.parse(month) < 10 ? "0$month" : month;
  String period = w.time.split(" ")[1];
  int hrs = int.parse((w.time.split(" ")[0]).split(":")[0]);
  String min = (w.time.split(" ")[0]).split(":")[1];
  if (hrs == 12 && period == "am") {
    hrs = 0;
  }
  if (period == "pm") {
    hrs = hrs + 12;
  }
  String withzerohr = "";
  withzerohr = hrs < 10 ? "0$hrs" : hrs.toString();

  return DateTime.parse("$year-$month-$date $withzerohr:$min:00");
}
