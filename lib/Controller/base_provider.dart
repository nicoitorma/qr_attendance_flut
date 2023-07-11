import 'package:flutter/material.dart';

abstract class BaseProvider extends ChangeNotifier {
  List list = [];
  List selectedTile = [];
  bool isLongPress = false;

  setLongPress() {
    isLongPress = !isLongPress;
    notifyListeners();
  }

  clearSelectedItems() {
    selectedTile.clear();
    notifyListeners();
  }

  selectTile(dynamic selected) {
    selectedTile.add(selected);
  }

  removeItemFromSelected(dynamic selected) {
    selectedTile.remove(selected);
  }

  selectAll() {
    selectedTile.clear();
    if (selectedTile.length == list.length) {
      return;
    } else {
      for (int i = 0; i < list.length; i++) {
        selectedTile.add(list[i]);
      }
    }
    notifyListeners();
  }
}
