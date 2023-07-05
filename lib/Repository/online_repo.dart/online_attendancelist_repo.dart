import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:qr_attendance_flut/utils/firebase_helper.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../../Models/attendance.dart';

final _db = FirebaseFirestore.instance;
final _crashlytics = FirebaseCrashlytics.instance;

String _generateRandomString() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  final codeUnits = List.generate(6, (index) => random.nextInt(chars.length));
  return String.fromCharCodes(codeUnits.map((unit) => chars.codeUnitAt(unit)));
}

getDocsContent() async {
  List<AttendanceModel> dataList = [];
  try {
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
  } catch (err) {
    _crashlytics.log('ONLINE ATTLIST REPO: ${err.toString()}');
  }
}

/// The function `deleteField` deletes a field from a document in a Firestore collection and also
/// deletes the document itself.
///
/// Args:
///   code (String): The "code" parameter in the "deleteField" function is a string that represents the
/// code or identifier of the field that needs to be deleted.
deleteField(String code) async {
  try {
    await _db
        .collection(labelCollection)
        .doc(labelAttendanceDocs)
        .update({code: FieldValue.delete()});
    _db.collection(labelCollection).doc(code).delete();
  } catch (err) {
    _crashlytics.log('ONLINE ATTLIST REPO: ${err.toString()}');
  }
}

/// The function removes a user from a list of users in a document in a Firestore database.
///
/// Args:
///   code (String): The `code` parameter is a string that represents a code used to identify a specific
/// entry in the database.
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
    _crashlytics.log('ONLINE ATTLIST REPO: ${err.toString()}');
  }
}

/// The function `joinAttendanceInFirestore` updates the `users` field in a Firestore document with the
/// provided `code` if the user's email is not already present in the list.
///
/// Args:
///   code (String): The `code` parameter is a string that represents a code used to identify a specific
/// attendance record in Firestore.
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
  } catch (err) {
    _crashlytics.log('ONLINE ATTLIST REPO: ${err.toString()}');
  }
}

createAttendanceInFirestore({required AttendanceModel attendanceModel}) async {
  String attendanceCode = _generateRandomString();
  try {
    /// This will add a new attendance to the document [attendances], it will be use to as reference for the users that
    /// has access to the document.
    await _db.collection(labelCollection).doc(labelAttendanceDocs).update({
      attendanceCode: {
        'attendanceName': attendanceModel.attendanceName,
        'details': attendanceModel.details,
        'timeAndDate': DateTime.now(),
        'cutoff': attendanceModel.cutoffTimeAndDate,
        'users': [getUserEmail()]
      }
    });

    /// This will create a new document in the collection where the scanned QR will be added.
    ///
    _db.collection(labelCollection).doc(attendanceCode).set({});
  } catch (err) {
    _crashlytics.log('ONLINE ATTLIST REPO: ${err.toString()}');
  }
}
