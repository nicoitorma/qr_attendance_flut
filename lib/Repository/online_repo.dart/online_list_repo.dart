import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Models/student_in_attendance.dart';

import '../../values/strings.dart';

class OnlineContentListRepo extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _crashlytics = FirebaseCrashlytics.instance;

  getAllContent(String attendanceCode) async {
    List<StudentInAttendance> dataList = [];
    try {
      final jsonDoc =
          await _db.collection(labelCollection).doc(attendanceCode).get();

      final data = jsonDoc.data();

      data?.forEach((key, value) {
        StudentInAttendance student =
            StudentInAttendance.fromDocumentSnapshot(key, value);
        dataList.add(student);
      });
      return dataList;
    } catch (err) {
      _crashlytics.log('ONLINE CONT REPO: ${err.toString()}');
    }
  }

  insertToContents(String attendanceCode, StudentInAttendance data) async {
    try {
      await _db.collection(labelCollection).doc(attendanceCode).update({
        data.idNum!: {
          'fullname': data.fullname,
          'dept': data.dept,
          'timeAndDate': data.timeAndDate,
          'isLate': data.isLate,
        }
      });
    } catch (err) {
      _crashlytics.log('ONLINE CONT REPO: ${err.toString()}');
    }
  }
}
