import 'dart:collection';
import 'package:tracking_app/models/weightclass.dart';
import 'package:flutter/material.dart';

class WeightProvider extends ChangeNotifier {
  final List<NewWeight> _item = [];
  UnmodifiableListView<NewWeight> get items => UnmodifiableListView(_item);

  void add(NewWeight w) {
    _item.add(w);
    notifyListeners();
  }

  void delete(NewWeight w) {
    _item.remove(w);
    notifyListeners();
  }
}
