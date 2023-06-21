import 'package:qr_attendance_flut/Models/attendance.dart';
import 'package:qr_attendance_flut/database/database.dart';
import 'package:sqflite/sqflite.dart';

getAllAttendance() async {
  final db = await AppDatabase().initializeDB();
  final List<Map<String, Object?>> queryResult =
      await db.query('attendance_table', orderBy: 'timeAndDate ASC');
  return queryResult.map((e) => AttendanceModel.fromJson(e)).toList();
}

insertAttendance(AttendanceModel attendanceModel) async {
  final db = await AppDatabase().initializeDB();
  return await db.insert('attendance_table', attendanceModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

deleteAttendance(int id) async {
  final db = await AppDatabase().initializeDB();
  await db.delete('attendance_table', where: 'id = ?', whereArgs: [id]);
}
