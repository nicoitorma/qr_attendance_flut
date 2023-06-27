import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Models/attendance.dart';
import 'package:qr_attendance_flut/Repository/online_repo.dart/online_attendancelist_repo.dart';
import 'package:qr_attendance_flut/utils/firebase_helper.dart';

class OnlineAttendanceListProvider extends ChangeNotifier {
  List<AttendanceModel> list = [];
  List selectedTile = [];
  bool isLongPress = false;

  setLongPress() {
    isLongPress = !isLongPress;
    notifyListeners();
  }

  Stream get attendanceList {
    var data = OnlineAttendanceRepo().fetchAttendance(getUserEmail());
    print(data);
    return data.stream;
  }

  fetchAttendance(Map<String, dynamic> item) {
    Map data = OnlineAttendanceRepo().fetchAttendance(getUserEmail());
    data.forEach((key, value) {
      if (value['users'].contains(getUserEmail())) {
        list.add(AttendanceModel.fromOnlineMap(item));
      }
    });
    print(list);
  }

  selectTile(AttendanceModel attendanceModel) {
    print('HERE');
    //selectedTile.add(attendanceModel);
  }
}
