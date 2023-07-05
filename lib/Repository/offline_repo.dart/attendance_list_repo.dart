import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance_flut/Models/attendance.dart';
import 'package:qr_attendance_flut/database/database.dart';
import 'package:qr_attendance_flut/values/strings.dart';
import 'package:sqflite/sqflite.dart';

final _crashlytics = FirebaseCrashlytics.instance;
getAllAttendance(DateTime day) async {
  final db = await AppDatabase().initializeDB();
  try {
    final formattedDate = DateFormat(labelDateFormat).format(day);
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(
      'SELECT * FROM attendance_table WHERE date = ?',
      [formattedDate],
    );
    return queryResult.map((e) => AttendanceModel.fromJson(e)).toList();
  } catch (err) {
    _crashlytics.log('OFFLINE ATTLIST REPO: ${err.toString()}');
  }
}

insertAttendance(AttendanceModel attendanceModel) async {
  final db = await AppDatabase().initializeDB();
  try {
    return await db.insert('attendance_table', attendanceModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  } catch (err) {
    _crashlytics.log('OFFLINE ATTLIST REPO: ${err.toString()}');
  }
}

deleteAttendance(int id) async {
  final db = await AppDatabase().initializeDB();
  try {
    await db.delete('attendance_table', where: 'id = ?', whereArgs: [id]);
  } catch (err) {
    _crashlytics.log('OFFLINE ATTLIST REPO: ${err.toString()}');
  }
}
