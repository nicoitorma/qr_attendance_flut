import 'package:qr_attendance_flut/Controller/base_provider.dart';
import 'package:qr_attendance_flut/Repository/online_repo.dart/online_list_repo.dart';
import 'package:qr_attendance_flut/utils/firebase_helper.dart';

import '../../Models/student_in_attendance.dart';

class OnlineAttendanceContentsProv extends BaseProvider {
  String idNum = '';
  String? attendanceCode;
  String? user;

  getAttndcContent(String user, String code) async {
    attendanceCode = code;
    this.user = user;
    if (user == getUserEmail()) {
      /// The user is not admin
      list = await OnlineContentListRepo().getAllContentForAdmin(code);
    } else {
      /// The user is admin
      list = await OnlineContentListRepo().getAllContent(user, code);
    }

    notifyListeners();
  }

  insertToAttendance(StudentInAttendance studentInAttendance) async {
    await OnlineContentListRepo()
        .insertToContents(attendanceCode!, studentInAttendance);
    getAttndcContent(user!, attendanceCode!);
    notifyListeners();
  }

  deleteItemOnDocument() async {
    for (var item in selectedTile) {
      await OnlineContentListRepo()
          .deleteOnDocument(attendanceCode!, item.idNum);
    }
    selectedTile.clear();
    await getAttndcContent(user!, attendanceCode!);
    notifyListeners();
  }
}
