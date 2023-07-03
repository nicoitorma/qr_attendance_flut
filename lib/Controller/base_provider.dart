import 'package:flutter/material.dart';

import '../Models/attendance.dart';

abstract class BaseProvider extends ChangeNotifier {
  List<AttendanceModel> attendanceList = [];
  List selectedTile = [];
  bool isLongPress = false;

  setLongPress() {
    isLongPress = !isLongPress;
    notifyListeners();
  }

  clearSelectedItems() {
    selectedTile.clear();
    // notifyListeners();
  }

  selectTile(AttendanceModel attendanceModel) {
    selectedTile.add(attendanceModel);
    // notifyListeners();
  }

  removeItemFromSelected(AttendanceModel attendanceModel) {
    selectedTile.remove(attendanceModel);
    // notifyListeners();
  }

  selectAll() {
    selectedTile.clear();
    if (selectedTile.length == attendanceList.length) {
      return;
    } else {
      for (int i = 0; i < attendanceList.length; i++) {
        selectedTile.add(attendanceList[i]);
      }
    }
    notifyListeners();
  }
}
