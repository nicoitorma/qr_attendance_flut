import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/database/database.dart';

import 'Views/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize the database
  await AppDatabase().initializeDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'QR Attendance',
      home: HomePage(),
    );
  }
}
