import 'package:qr_attendance_flut/Models/student_in_attendance.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database.dart';

getAllAttendanceContent() async {
  final db = await AppDatabase().initializeDB();
  final List<Map<String, Object?>> queryResult =
      await db.query('studentInAttendance_db', orderBy: 'id ASC');
  return queryResult.map((e) => StudentInAttendance.fromJson(e)).toList();
}

insertAttendanceContent(StudentInAttendance studentInAttendance) async {
  final db = await AppDatabase().initializeDB();
  return await db.insert('studentInAttendance_db', studentInAttendance.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

deleteAttendance(int id) async {
  final db = await AppDatabase().initializeDB();
  await db.delete('studentInAttendance_db', where: 'id = ?', whereArgs: [id]);
}
