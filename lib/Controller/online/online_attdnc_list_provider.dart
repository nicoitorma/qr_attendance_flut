import 'package:qr_attendance_flut/Controller/base_provider.dart';
import 'package:qr_attendance_flut/Models/attendance.dart';
import 'package:qr_attendance_flut/Repository/online_repo.dart/online_attendancelist_repo.dart';

import '../../utils/firebase_helper.dart';

class OnlineAttendanceListProvider extends BaseProvider {
  /// This function fetches attendance data from an online repository and adds it to a list if the user's
  /// email is included in the data.
  getAttendance() async {
    List? localList = [];
    localList = await getDocsContent();
    if (localList != null) {
      list = localList;
    }
    notifyListeners();
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
