import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tracking_app/functions/mydatetime.dart';
import 'package:tracking_app/models/waterclass.dart';

class WaterProvider extends ChangeNotifier {
  final List<DayWater> _items = [];

  UnmodifiableListView<DayWater> get items => UnmodifiableListView(_items);

  void add(
    double intakeml,
    double outputml,
    double miscml,
    String date,
    String time,
    String notes,
  ) {
    bool added = false;
    if (_items.isEmpty) {
      _items.insert(
          0, DayWater(intakeml: 0, outputml: 0, date: date, dayContents: []));
      addingContentsAtIndex(intakeml, outputml, miscml, date, time, notes, 0);
    } else {
      for (int i = 0; i < _items.length; i++) {
        if (date == _items[i].date) {
          added = true;
          addingContentsAtIndex(
              intakeml, outputml, miscml, date, time, notes, i);
          break;
        }
      }
      if (added == false) {
        for (int i = 0; i < _items.length; i++) {
          // print(_items[i].date);
          DateTime functiondatetime = mydatetime(date, time);
          DateTime indexdatetime = mydatetime(_items[i].date, time);
          if (functiondatetime.isAfter(indexdatetime)) {
            added = true;
            _items.insert(
                i,
                DayWater(
                    intakeml: 0, outputml: 0, date: date, dayContents: []));
            addingContentsAtIndex(
                intakeml, outputml, miscml, date, time, notes, i);
            break;
          }
        }
      }
      if (added == false) {
        _items.add(
            DayWater(intakeml: 0, outputml: 0, date: date, dayContents: []));
        addingContentsAtIndex(
                intakeml, outputml, miscml, date, time, notes, _items.length-1);  
      }
    }

    // print(_items[0]);
    notifyListeners();
  }

  void addingContentsAtIndex(
    double intakeml,
    double outputml,
    double miscml,
    String date,
    String time,
    String notes,
    int i,
  ) {
    if (intakeml != 0) {
      _items[i].dayContents.add(NewWater(
          value: intakeml,
          type: Watertype.intake,
          date: date,
          time: time,
          notes: notes));
    }
    if (outputml != 0) {
      _items[i].dayContents.add(NewWater(
          value: outputml,
          type: Watertype.output,
          date: date,
          time: time,
          notes: notes));
    }
    if (miscml != 0) {
      _items[i].dayContents.add(NewWater(
          value: miscml,
          type: Watertype.misc,
          date: date,
          time: time,
          notes: notes));
    }
    _items[i].intakeml += intakeml + miscml;
    _items[i].outputml += outputml;
  }
}
