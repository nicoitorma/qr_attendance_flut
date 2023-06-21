import 'package:qr_attendance_flut/Models/student_in_attendance.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database.dart';

getAllAttendanceContent() async {
  final db = await AppDatabase().initializeDB();
  final List<Map<String, Object?>> queryResult =
      await db.query('studentAdded_table', orderBy: 'id ASC');
  return queryResult.map((e) => StudentInAttendance.fromJson(e)).toList();
}

insertAttendanceContent(StudentInAttendance studentInAttendance) async {
  final db = await AppDatabase().initializeDB();
  return await db.insert('studentAdded_table', studentInAttendance.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

deleteFromAttendance(int id) async {
  final db = await AppDatabase().initializeDB();
  await db.delete('studentAdded_table', where: 'id = ?', whereArgs: [id]);
}
