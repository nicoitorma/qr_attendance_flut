import 'package:flutter/material.dart';

import '../../Models/attendance.dart';
import '../../Repository/offline_repo.dart/attendance_list_repo.dart';

class AttendanceListProvider extends ChangeNotifier {
  List<AttendanceModel> list = [];
  final List<AttendanceModel> selectedTile = [];
  DateTime? _day;
  bool isLongPress = false;

  setLongPress() {
    isLongPress = !isLongPress;
    notifyListeners();
  }

  getAttendanceListForDay(DateTime day) async {
    _day = day;
    list = await getAllAttendance(day);
    notifyListeners();
  }

  insertNewAttendance(AttendanceModel attendanceModel) async {
    await insertAttendance(attendanceModel);
    await getAttendanceListForDay(_day!);
  }

  selectAttendance(AttendanceModel attendanceModel) {
    selectedTile.add(attendanceModel);
    notifyListeners();
  }

  clearSelectedItems() {
    selectedTile.clear();
    notifyListeners();
  }

  removeItemFromSelected(AttendanceModel attendanceModel) {
    selectedTile.remove(attendanceModel);
    notifyListeners();
  }

  deleteItem() async {
    for (var item in selectedTile) {
      await deleteAttendance(item.id!);
    }
    selectedTile.clear();
    await getAttendanceListForDay(_day!);
    notifyListeners();
  }

  /// A function that will select all the item in the attendance list
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
