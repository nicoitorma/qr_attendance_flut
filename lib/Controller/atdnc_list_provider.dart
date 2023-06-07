import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Repository/attendance_list_repo.dart';

import '../Models/attendance.dart';

class AttendanceListProvider extends ChangeNotifier {
  List<AttendanceModel> attendanceList = [];
  List<AttendanceModel> clickedAttendance = [];

  getAttendanceList() async {
    attendanceList = await getAllAttendance();
    notifyListeners();
  }

  insertNewAttendance(AttendanceModel attendanceModel) async {
    await insertAttendance(attendanceModel);
    await getAttendanceList();
  }

  selectAttendance(AttendanceModel attendanceModel) {
    clickedAttendance.add(attendanceModel);
    notifyListeners();
  }

  clearSelectedItems() {
    clickedAttendance.clear();
    notifyListeners();
  }

  removeItemFromSelected(AttendanceModel attendanceModel) {
    clickedAttendance.remove(attendanceModel);
    notifyListeners();
  }

  deleteItem() async {
    for (var item in clickedAttendance) {
      await deleteAttendance(item.id!);
    }
    clickedAttendance.clear();
    await getAttendanceList();
    notifyListeners();
  }

  /// A function that will select all the item in the attendance list
  selectAll() {
    clickedAttendance.clear();
    if (clickedAttendance.length == attendanceList.length) {
      return;
    } else {
      for (int i = 0; i < attendanceList.length; i++) {
        clickedAttendance.add(attendanceList[i]);
      }
    }
    notifyListeners();
  }
}
