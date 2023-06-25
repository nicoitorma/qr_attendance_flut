import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/values/strings.dart';

class OnlineAttendanceRepo {
  final _db = FirebaseFirestore.instance;

  String _generateRandomString() {
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    final random = Random();
    final codeUnits = List.generate(5, (index) => random.nextInt(chars.length));
    return String.fromCharCodes(
        codeUnits.map((unit) => chars.codeUnitAt(unit)));
  }

  fetchAttendance() {
    try {
      Stream result = _db
          .collection(
              labelAttendanceCollection) // Replace with your collection name
          .doc('user1') // Replace with your document ID
          .snapshots();

      return result;
    } catch (err) {
      debugPrint('Error fetching document: $err');
    }
  }

  void createAttendance({int count = 0}) async {
    List data = ['data1', 'data2', 'data3', 'data4', 'data5'];
    try {
      await _db.collection(labelAttendanceCollection).doc('user1').update({
        _generateRandomString(): {
          'attendanceName': data[count],
          'details': 'hehe',
          'timeAndDate': DateTime.now()
        },
      });
      print('Document created successfully.');
    } catch (e) {
      print('Error creating document: $e');
    }
  }
}
