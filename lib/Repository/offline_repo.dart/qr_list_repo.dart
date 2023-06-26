import 'package:sqflite/sqflite.dart';

import '../../Models/qr_code.dart';
import '../../database/database.dart';

getAllQr() async {
  final db = await AppDatabase().initializeDB();
  final List<Map<String, Object?>> queryResult = await db.query('qr_table');
  return queryResult.map((e) => QrModel.fromJson(e)).toList();
}

createNewQr(QrModel qrModel) async {
  final db = await AppDatabase().initializeDB();
  return await db.insert('qr_table', qrModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

deleteQr(int id) async {
  final db = await AppDatabase().initializeDB();
  await db.delete('qr_table', where: 'id = ?', whereArgs: [id]);
}
