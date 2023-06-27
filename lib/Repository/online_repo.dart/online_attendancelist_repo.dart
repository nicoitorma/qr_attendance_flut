import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/utils/firebase_helper.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../../Models/attendance.dart';

class OnlineAttendanceRepo {
  final _db = FirebaseFirestore.instance;

  String _generateRandomString() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final codeUnits = List.generate(6, (index) => random.nextInt(chars.length));
    return String.fromCharCodes(
        codeUnits.map((unit) => chars.codeUnitAt(unit)));
  }

  fetchAttendance(String acctEmail) {
    try {
      Stream result =
          _db.collection(labelCollection).doc(labelAttendanceDocs).snapshots();

      return result;
    } catch (err) {
      debugPrint('Error fetching document: $err');
    }
  }

  joinAttendance({String? code}) async {
    final document = FirebaseFirestore.instance
        .collection(labelCollection)
        .doc(labelAttendanceDocs);

    try {
      DocumentSnapshot docSnapshot = await document.get();
      // Update the value of the `users` field in the inner map.
      Map<String, dynamic> data = docSnapshot.data()! as Map<String, dynamic>;
      List innerMap = data[code]['users'];
      if (!innerMap.contains(getUserEmail())) {
        innerMap.add(getUserEmail());
        await document.update(data);
      }
    } catch (err) {
      debugPrint('Contents: Not Found');
    }
  }

  void createAttendance({required AttendanceModel attendanceModel}) async {
    try {
      await FirebaseFirestore.instance
          .collection(labelCollection)
          .doc(labelAttendanceDocs)
          .update({
        _generateRandomString(): {
          'attendanceName': attendanceModel.attendanceName,
          'details': attendanceModel.details,
          'timeAndDate': DateTime.now(),
          'cutoff': attendanceModel.cutoffTimeAndDate,
          'users': [getUserEmail()]
        }
      });
    } catch (e) {
      debugPrint('Error creating document: $e');
    }
  }
}
