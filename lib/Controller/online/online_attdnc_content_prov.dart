import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Models/student_in_attendance.dart';
import 'package:qr_attendance_flut/Repository/online_repo.dart/online_list_repo.dart';

class OnlineAttendanceContentsProv extends ChangeNotifier {
  List<StudentInAttendance> list = [];
  List<StudentInAttendance> selectedTile = [];
  String idNum = '';
  bool isLongPress = false;

  setLongPress() {
    isLongPress = !isLongPress;
    notifyListeners();
  }

  getAtndContent() async {
    list = await OnlineContentListRepo().getAllContent();
    print(list.map((e) => e.fullname));
    notifyListeners();
  }

  // insertToAttendance(StudentInAttendance studentInAttendance) async {
  //   await OnlineContentListRepo().insertAttendanceContent(studentInAttendance);
  //   await getAtndContent(_attendanceId);
  // }

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

  // deleteItem() async {
  //   for (var item in selectedTile) {
  //     await OnlineContentListRepo().deleteFromAttendance(item.id!);
  //   }
  //   selectedTile.clear();
  //   await getAtndContent(_attendanceId);
  //   notifyListeners();
  // }

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
