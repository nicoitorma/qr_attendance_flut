import 'package:qr_attendance_flut/Controller/base_provider.dart';
import 'package:qr_attendance_flut/Repository/online_repo.dart/online_list_repo.dart';

import '../../Models/student_in_attendance.dart';

class OnlineAttendanceContentsProv extends BaseProvider {
  String idNum = '';
  String? attendanceCode;

  getAttndcContent(String code) async {
    attendanceCode = code;
    list = await OnlineContentListRepo().getAllContent(code);
    notifyListeners();
  }

  insertToAttendance(StudentInAttendance studentInAttendance) async {
    await OnlineContentListRepo()
        .insertToContents(attendanceCode!, studentInAttendance);
    getAttndcContent(attendanceCode!);
    notifyListeners();
  }

  deleteItemOnDocument() async {
    for (var item in selectedTile) {
      await OnlineContentListRepo()
          .deleteOnDocument(attendanceCode!, item.idNum);
    }
    selectedTile.clear();
    await getAttndcContent(attendanceCode!);
    notifyListeners();
  }
}
