import 'package:qr_attendance_flut/Controller/base_provider.dart';
import 'package:qr_attendance_flut/Models/student_in_attendance.dart';

import '../../Repository/offline_repo.dart/attendance_content_repo.dart';

class AttendanceContentProvider extends BaseProvider {
  final AttendanceContentRepo _attendanceContentRepo = AttendanceContentRepo();

  int _attendanceId = 0;

  getAtndContent(int attendanceId) async {
    _attendanceId = attendanceId;
    list = await _attendanceContentRepo.getAllAttendanceContent(attendanceId);
    notifyListeners();
  }

  insertToAttendance(StudentInAttendance studentInAttendance) async {
    await _attendanceContentRepo.insertAttendanceContent(studentInAttendance);
    await getAtndContent(_attendanceId);
  }

  deleteItem() async {
    for (var item in selectedTile) {
      await _attendanceContentRepo.deleteFromAttendance(item.id!);
    }
    selectedTile.clear();
    await getAtndContent(_attendanceId);
    notifyListeners();
  }
}
