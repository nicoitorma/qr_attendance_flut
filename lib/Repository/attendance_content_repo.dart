import 'package:qr_attendance_flut/Models/student_in_attendance.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database.dart';

getAllAttendanceContent(int attendanceId) async {
  final db = await AppDatabase().initializeDB();
  final List<Map<String, Object?>> queryResult = await db.query(
      'studentAdded_table',
      where: 'attendanceId = ?',
      whereArgs: [attendanceId],
      orderBy: 'id ASC');
  db.close();
  return queryResult.map((e) => StudentInAttendance.fromJson(e)).toList();
}

isAlreadyAdded(String idNum) async {
  final db = await AppDatabase().initializeDB();
  final result = await db.rawQuery(
      'SELECT EXISTS (SELECT 1 FROM studentAdded_table WHERE $idNum = ?)',
      [idNum]);

  return Sqflite.firstIntValue(result) == 1;
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
