import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Models/student_in_attendance.dart';

import '../../values/strings.dart';

class OnlineContentListRepo extends ChangeNotifier {
  getAllContent() async {
    List<StudentInAttendance> dataList = [];
    final jsonDoc = await FirebaseFirestore.instance
        .collection(labelCollection)
        .doc(labelAttendanceContentDocs)
        .get();

    final data = jsonDoc.data();
    print(data);

    data!.forEach((key, value) {
      if (value['code'] == 'zja5xj') {
        StudentInAttendance student =
            StudentInAttendance.fromDocumentSnapshot(key, value);
        dataList.add(student);
      }
    });
    return dataList;
  }
}
