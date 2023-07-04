import 'package:qr_attendance_flut/Controller/base_provider.dart';
import 'package:qr_attendance_flut/Repository/online_repo.dart/online_list_repo.dart';

class OnlineAttendanceContentsProv extends BaseProvider {
  String idNum = '';

  getAttndcContent() async {
    list = await OnlineContentListRepo().getAllContent();
    notifyListeners();
  }

  // insertToAttendance(StudentInAttendance studentInAttendance) async {
  //   await OnlineContentListRepo().insertAttendanceContent(studentInAttendance);
  //   await getAtndContent(_attendanceId);
  // }

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
