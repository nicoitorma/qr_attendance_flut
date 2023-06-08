import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Models/student_in_attendance.dart';
import 'package:qr_attendance_flut/Repository/attendance_content_repo.dart';

class AttendanceContentProvider extends ChangeNotifier {
  List content = [];

  getAtndContent() async {
    content = await getAllAttendanceContent();
    notifyListeners();
  }

  insertToAttendance(StudentInAttendance studentInAttendance) async {
    await insertAttendanceContent(studentInAttendance);
    await getAtndContent();
  }
}
