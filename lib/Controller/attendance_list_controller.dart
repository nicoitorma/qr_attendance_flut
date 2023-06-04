import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Repository/attendance_list_repository.dart';

import '../Models/attendance.dart';

class AttendanceListProvider extends ChangeNotifier {
  List<AttendanceModel> attendanceList = [];

  getAttendanceList() async {
    attendanceList = await getAllAttendance();
    notifyListeners();
  }
}
