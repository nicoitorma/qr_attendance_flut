import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Models/attendance.dart';

import '../../../utils/firebase_helper.dart';
import '../../../values/strings.dart';

class DbFirestore extends ChangeNotifier {
  List<AttendanceModel> list = [];

  Future convertDocsFromFirestore() async {
    final jsonDoc = await FirebaseFirestore.instance
        .collection(labelCollection)
        .doc(labelAttendanceDocs)
        .get();

    final data = jsonDoc.data();
    list.clear();
    data!.forEach((key, value) {
      if (value['users'].contains(getUserEmail())) {
        AttendanceModel attendance =
            AttendanceModel.fromDocumentSnapshot(key, value);
        list.add(attendance);
      }
    });
    notifyListeners();
  }
}
