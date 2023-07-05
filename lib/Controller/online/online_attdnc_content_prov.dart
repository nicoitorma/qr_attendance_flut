import 'package:qr_attendance_flut/Controller/base_provider.dart';
import 'package:qr_attendance_flut/Repository/online_repo.dart/online_list_repo.dart';

import '../../Models/student_in_attendance.dart';

class OnlineAttendanceContentsProv extends BaseProvider {
  String idNum = '';
  String? attendanceCode;

  getAttndcContent(String code) async {
    print('GET ATTENDANCE');
    attendanceCode = code;
    list = await OnlineContentListRepo().getAllContent(code);
    notifyListeners();
  }

  insertToAttendance(StudentInAttendance studentInAttendance) async {
    print('PROV: $attendanceCode');
    await OnlineContentListRepo()
        .insertToContents(attendanceCode!, studentInAttendance);
    // getAttndcContent(attendanceCode!);
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
  @override
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
