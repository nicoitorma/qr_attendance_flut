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
      Stream result = _db
          .collection(
              labelAttendanceCollection) // Replace with your collection name
          .doc('sample@gmail.com') // Replace with your document ID
          .snapshots();

      return result;
    } catch (err) {
      debugPrint('Error fetching document: $err');
    }
  }

  void createAttendance({required AttendanceModel attendanceModel}) async {
    try {
      await FirebaseFirestore.instance
          .collection(labelAttendanceCollection)
          .doc(getUserEmail())
          .update({
        _generateRandomString(): {
          'attendanceName': attendanceModel.attendanceName,
          'details': attendanceModel.details,
          'timeAndDate': DateTime.now(),
          'cutoff': attendanceModel.cutoffTimeAndDate
        }
      });
    } catch (e) {
      debugPrint('Error creating document: $e');
    }
  }
}
