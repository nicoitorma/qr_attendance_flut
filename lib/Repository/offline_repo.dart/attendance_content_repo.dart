import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:qr_attendance_flut/Models/student_in_attendance.dart';
import 'package:sqflite/sqflite.dart';

import '../../database/database.dart';

class AttendanceContentRepo {
  final _crashlytics = FirebaseCrashlytics.instance;

  /// The function `getAllAttendanceContent` retrieves all the student attendance records for a given
  /// attendance ID from a database table and returns them as a list of `StudentInAttendance` objects.
  ///
  /// Args:
  ///   attendanceId (int): The `attendanceId` parameter is an integer that represents the unique
  /// identifier of the attendance record. It is used as a filter in the database query to retrieve all
  /// the attendance content for a specific attendance record.
  ///
  /// Returns:
  ///   a list of objects of type `StudentInAttendance`.
  getAllAttendanceContent(int attendanceId) async {
    final db = await AppDatabase().initializeDB();
    try {
      final List<Map<String, Object?>> queryResult = await db.query(
          'studentAdded_table',
          where: 'attendanceId = ?',
          whereArgs: [attendanceId],
          orderBy: 'id ASC');
      db.close();
      return queryResult.map((e) => StudentInAttendance.fromJson(e)).toList();
    } catch (err) {
      _crashlytics.log('OFFLINE CONT REPO: ${err.toString()}');
    }
  }

  static isAlreadyAdded(String idNum, int attendanceId) async {
    final db = await AppDatabase().initializeDB();

    final result = await db.rawQuery(
        'SELECT COUNT($idNum) FROM studentAdded_table WHERE idNum = ? AND attendanceId = ?',
        [idNum, attendanceId]);
    int? count = Sqflite.firstIntValue(result);
    return count;
  }

  /// The function inserts attendance content for a student into a database table.
  ///
  /// Args:
  ///   studentInAttendance (StudentInAttendance): The parameter `studentInAttendance` is an object of
  /// type `StudentInAttendance`. It represents a student who is present in a class or event.
  ///
  /// Returns:
  ///   The method is returning the result of the `db.insert` operation, which is a Future<int>.
  insertAttendanceContent(StudentInAttendance studentInAttendance) async {
    final db = await AppDatabase().initializeDB();
    try {
      return await db.insert('studentAdded_table', studentInAttendance.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (err) {
      _crashlytics.log('OFFLINE CONT REPO: ${err.toString()}');
    }
  }

  /// The function deletes a student's attendance record from the 'studentAdded_table' in the database
  /// based on the provided id.
  ///
  /// Args:
  ///   id (int): The "id" parameter is the unique identifier of the student whose attendance record
  /// needs to be deleted from the "studentAdded_table" table in the database.
  /// The function deletes an attendance record based on the provided ID.
  ///
  /// Args:
  ///   id (int): The id parameter is the unique identifier of the attendance record that you want to
  /// delete.
  deleteFromAttendance(int id) async {
    final db = await AppDatabase().initializeDB();
    try {
      await db.delete('studentAdded_table', where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      _crashlytics.log('OFFLINE CONT REPO: ${err.toString()}');
    }
  }
}
