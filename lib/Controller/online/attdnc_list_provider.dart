import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Models/attendance.dart';

class OnlineAttendanceListProvider extends ChangeNotifier {
  List list = [];
  List selectedTile = [];
  bool isLongPress = false;

  setLongPress() {
    isLongPress = !isLongPress;
    notifyListeners();
  }

  selectTile(AttendanceModel attendanceModel) {
    print('HERE');
    //selectedTile.add(attendanceModel);
    notifyListeners();
  }
}
