import 'package:qr_attendance_flut/Models/student_in_attendance.dart';
import 'package:sqflite/sqflite.dart';

import '../../database/database.dart';

class AttendanceContentRepo {
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

  static isAlreadyAdded(String idNum, int attendanceId) async {
    final db = await AppDatabase().initializeDB();

    final result = await db.rawQuery(
        'SELECT COUNT($idNum) FROM studentAdded_table WHERE idNum = ? AND attendanceId = ?',
        [idNum, attendanceId]);
    int? count = Sqflite.firstIntValue(result);
    return count;
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
}
