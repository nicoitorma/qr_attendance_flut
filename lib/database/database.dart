import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE IF NOT EXISTS attendance_table(aId INTEGER PRIMARY KEY AUTOINCREMENT, attendanceName TEXT NOT NULL, details TEXT, date DATETIME, time DATETIME, cutoffTimeAndDate DATETIME)",
        );
        await database.execute(
          "CREATE TABLE IF NOT EXISTS qr_table(id INTEGER PRIMARY KEY AUTOINCREMENT, fullname TEXT NOT NULL, idNum TEXT, dept TEXT)",
        );
        await database.execute(
          "CREATE TABLE IF NOT EXISTS studentAdded_table(id INTEGER PRIMARY KEY AUTOINCREMENT, idNum TEXT, fullname TEXT NOT NULL, dept TEXT, timeAndDate TEXT, isLate TEXT, aId INTEGER, FOREIGN KEY (aId) REFERENCES attendance_table(aId));",
        );
      },
      version: 1,
    );
  }
}
