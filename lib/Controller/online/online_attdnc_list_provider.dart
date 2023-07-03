import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Models/attendance.dart';
import 'package:qr_attendance_flut/Repository/online_repo.dart/online_attendancelist_repo.dart';

import '../../utils/firebase_helper.dart';

class OnlineAttendanceListProvider extends ChangeNotifier {
  List<AttendanceModel> attendanceList = [];
  List selectedTile = [];
  bool isLongPress = false;

  setLongPress() {
    isLongPress = !isLongPress;
    notifyListeners();
  }

  /// This function fetches attendance data from an online repository and adds it to a list if the user's
  /// email is included in the data.
  getAttendance() async {
    attendanceList = await convertDocsFromFirestore();
    print(attendanceList.map((e) => e.attendanceName));
    notifyListeners();
  }

  selectTile(AttendanceModel attendanceModel) {
    selectedTile.add(attendanceModel);
  }

  removeItemFromSelected(AttendanceModel attendanceModel) {
    selectedTile.remove(attendanceModel);
  }

  joinAttendance(String code) async {
    await joinAttendanceInFirestore(code);
    getAttendance();
  }

  createAttendance(AttendanceModel attendanceModel) async {
    await createAttendanceInFirestore(attendanceModel: attendanceModel);
    getAttendance();
  }

  // The function deletes items from Firestore based on user email and updates the UI.
  deleteItemOnFirestore() async {
    for (var item in selectedTile) {
      if (item.user == getUserEmail()) {
        await deleteField(item.attendanceCode!);
      } else {
        await removeUser(item.attendanceCode!);
      }
    }
    selectedTile.clear();
    getAttendance();
    // notifyListeners();
  }
}
