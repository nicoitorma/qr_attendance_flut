import 'package:qr_attendance_flut/Models/attendance.dart';
import 'package:qr_attendance_flut/database/database.dart';
import 'package:sqflite/sqflite.dart';

class AttendanceRepo {
  Future<List<AttendanceModel>> getAllAttendance() async {
    final db = await AppDatabase().initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('attendance_table', orderBy: 'dateTime ASC');
    return queryResult.map((e) => AttendanceModel.fromMap(e)).toList();
  }

  Future newAttendance(AttendanceModel attendanceModel) async {
    final db = await AppDatabase().initializeDB();
    return await db.insert('attendance_table', attendanceModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
