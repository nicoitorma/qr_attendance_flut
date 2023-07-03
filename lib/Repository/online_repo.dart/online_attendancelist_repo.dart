import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/utils/firebase_helper.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../../Models/attendance.dart';

final _db = FirebaseFirestore.instance;

String _generateRandomString() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  final codeUnits = List.generate(6, (index) => random.nextInt(chars.length));
  return String.fromCharCodes(codeUnits.map((unit) => chars.codeUnitAt(unit)));
}

convertDocsFromFirestore() async {
  List<AttendanceModel> dataList = [];
  final jsonDoc = await FirebaseFirestore.instance
      .collection(labelCollection)
      .doc(labelAttendanceDocs)
      .get();

  final data = jsonDoc.data();

  data!.forEach((key, value) {
    if (value['users'].contains(getUserEmail())) {
      AttendanceModel attendance =
          AttendanceModel.fromDocumentSnapshot(key, value);
      dataList.add(attendance);
    }
  });
  return dataList;
}

deleteField(String code) async {
  try {
    await _db
        .collection(labelCollection)
        .doc(labelAttendanceDocs)
        .update({code: FieldValue.delete()});
    print('Field deleted successfully.');
  } catch (err) {
    print('Error deleting field: $err');
  }
}

removeUser(String code) async {
  final document = _db.collection(labelCollection).doc(labelAttendanceDocs);

  try {
    DocumentSnapshot docSnapshot = await document.get();
    // Update the value of the `users` field in the inner map.
    Map<String, dynamic> data = docSnapshot.data()! as Map<String, dynamic>;
    List innerMap = data[code]['users'];

    if (innerMap.contains(getUserEmail())) {
      innerMap.remove(getUserEmail());
      await document.update(data);
    }
  } catch (err) {
    debugPrint('Error: $err');
  }
}

joinAttendanceInFirestore(String code) async {
  try {
    final document = _db.collection(labelCollection).doc(labelAttendanceDocs);
    DocumentSnapshot docSnapshot = await document.get();
    // Update the value of the `users` field in the inner map.
    Map<String, dynamic> data = docSnapshot.data()! as Map<String, dynamic>;
    List innerMap = data[code]['users'];
    if (!innerMap.contains(getUserEmail())) {
      innerMap.add(getUserEmail());
      await document.update(data);
    }
    print('Success joining attendance');
  } catch (err) {
    debugPrint('Error: $err');
  }
}

createAttendanceInFirestore({required AttendanceModel attendanceModel}) async {
  try {
    await _db.collection(labelCollection).doc(labelAttendanceDocs).update({
      _generateRandomString(): {
        'attendanceName': attendanceModel.attendanceName,
        'details': attendanceModel.details,
        'timeAndDate': DateTime.now(),
        'cutoff': attendanceModel.cutoffTimeAndDate,
        'users': [getUserEmail()]
      }
    });
    return 'Success creating attendance';
  } catch (e) {
    debugPrint('Error creating document: $e');
  }
}
