import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Models/student_in_attendance.dart';

import '../../values/strings.dart';

class OnlineContentListRepo extends ChangeNotifier {
  getAllContent(String attendanceCode) async {
    List<StudentInAttendance> dataList = [];
    final jsonDoc = await FirebaseFirestore.instance
        .collection(labelCollection)
        .doc(attendanceCode)
        .get();

    final data = jsonDoc.data();

    data?.forEach((key, value) {
      StudentInAttendance student =
          StudentInAttendance.fromDocumentSnapshot(key, value);
      dataList.add(student);
    });
    return dataList;
  }

  insertToContents(String attendanceCode, StudentInAttendance data) async {
    try {
      await FirebaseFirestore.instance
          .collection(labelCollection)
          .doc(attendanceCode)
          .update({
        data.idNum!: {
          'fullname': data.fullname,
          'dept': data.dept,
          'timeAndDate': data.timeAndDate,
          'isLate': data.isLate,
        }
      });
      print('Success adding student');
    } catch (e) {
      debugPrint('Error creating document: $e');
    }
  }
}
