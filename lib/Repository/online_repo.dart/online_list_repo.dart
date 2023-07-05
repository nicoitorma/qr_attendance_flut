import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Models/student_in_attendance.dart';
import 'package:qr_attendance_flut/utils/firebase_helper.dart';

import '../../values/strings.dart';

class OnlineContentListRepo extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _crashlytics = FirebaseCrashlytics.instance;

  /// The function `getAllContent` retrieves a list of `StudentInAttendance` objects from a Firestore
  /// database based on the provided user and attendance code.
  ///
  /// Args:
  ///   user (String): The "user" parameter is a string that represents the user for whom the attendance
  /// data is being fetched. It could be an email address or any other identifier that uniquely
  /// identifies the user.
  ///   attendanceCode (String): The attendanceCode parameter is a string that represents the code or
  /// identifier for a specific attendance session. It is used to retrieve the attendance data for that
  /// session from the database.
  ///
  /// Returns:
  ///   The method is returning a List of StudentInAttendance objects.
  getAllContent(String user, String attendanceCode) async {
    List<StudentInAttendance> dataList = [];
    try {
      final jsonDoc =
          await _db.collection(labelCollection).doc(attendanceCode).get();

      final data = jsonDoc.data();

      data?.forEach((key, value) {
        if (value['scanner'] == getUserEmail()) {
          StudentInAttendance student =
              StudentInAttendance.fromDocumentSnapshot(key, value);
          dataList.add(student);
        }
      });
      return dataList;
    } catch (err) {
      _crashlytics.log('ONLINE CONT REPO: ${err.toString()}');
    }
  }

  /// The function retrieves all content for an admin based on an attendance code.
  ///
  /// Args:
  ///   attendanceCode (String): The attendanceCode parameter is a unique identifier for a specific
  /// attendance record. It is used to retrieve the attendance data for that particular record.
  ///
  /// Returns:
  ///   The method is returning a list of StudentInAttendance objects.
  getAllContentForAdmin(String attendanceCode) async {
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
          'scanner': getUserEmail()
        }
      });
    } catch (err) {
      _crashlytics.log('ONLINE CONT REPO: ${err.toString()}');
    }
  }

  deleteOnDocument(String attendanceCode, String idNum) async {
    try {
      final document = _db.collection(labelCollection).doc(attendanceCode);

      // Delete the `name` field from the document
      await document.update({idNum: FieldValue.delete()});
    } catch (err) {
      _crashlytics.log('ONLINE CONT REPO: ${err.toString()}');
    }
  }
}
