import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Models/student_in_attendance.dart';
import 'package:qr_attendance_flut/Repository/attendance_content_repo.dart';

class AttendanceContentProvider extends ChangeNotifier {
  final AttendanceContentRepo _attendanceContentRepo = AttendanceContentRepo();
  List<StudentInAttendance> list = [];
  List<StudentInAttendance> selectedTile = [];
  int _attendanceId = 0;
  bool isLongPress = false;

  setLongPress() {
    isLongPress = !isLongPress;
    notifyListeners();
  }

  getAtndContent(int attendanceId) async {
    _attendanceId = attendanceId;
    list = await _attendanceContentRepo.getAllAttendanceContent(attendanceId);
    notifyListeners();
  }

  insertToAttendance(StudentInAttendance studentInAttendance) async {
    await _attendanceContentRepo.insertAttendanceContent(studentInAttendance);
    await getAtndContent(_attendanceId);
  }

  selectTile(StudentInAttendance studentInAttendance) {
    selectedTile.add(studentInAttendance);
    notifyListeners();
  }

  clearSelectedItems() {
    selectedTile.clear();
    notifyListeners();
  }

  removeItemFromSelected(StudentInAttendance studentInAttendance) {
    selectedTile.remove(studentInAttendance);
    notifyListeners();
  }

  deleteItem() async {
    for (var item in selectedTile) {
      await _attendanceContentRepo.deleteFromAttendance(item.id!);
    }
    selectedTile.clear();
    await getAtndContent(_attendanceId);
    notifyListeners();
  }

  /// A function that will select all the item in the attendance _list
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
