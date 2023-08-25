import 'package:qr_attendance_flut/Controller/base_provider.dart';

import '../../Models/attendance.dart';
import '../../Repository/offline_repo.dart/attendance_list_repo.dart';

class AttendanceListProvider extends BaseProvider {
  DateTime? _day;
  getAttendanceListForDay(DateTime day) async {
    List? localList = [];
    _day = day;
    localList = await getAllAttendance(day);
    if (localList != null) {
      list = localList;
    }
    notifyListeners();
  }

  createAttendance(AttendanceModel attendanceModel) async {
    await insertAttendance(attendanceModel);
    await getAttendanceListForDay(_day!);
  }

  deleteItem() async {
    for (var item in selectedTile) {
      await deleteAttendance(item.id!);
    }
    selectedTile.clear();
    await getAttendanceListForDay(_day!);
    notifyListeners();
  }
}
