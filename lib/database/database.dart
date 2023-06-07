import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE IF NOT EXISTS attendance_table(id INTEGER PRIMARY KEY AUTOINCREMENT, attendanceName TEXT NOT NULL, details TEXT, dateTime TEXT, cutoff TEXT)",
        );
        await database.execute(
          "CREATE TABLE IF NOT EXISTS qr_table(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, idNum TEXT, college TEXT)",
        );
      },
      version: 1,
    );
  }
}
