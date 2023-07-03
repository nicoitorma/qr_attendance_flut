import 'package:flutter/material.dart';

import '../../../Models/attendance.dart';

class HomepageProv extends ChangeNotifier {
  List<AttendanceModel> currentList = [];

  updateList(List<AttendanceModel> list) => currentList = list;
}
