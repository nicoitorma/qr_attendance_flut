import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Controller/atdnc_content_provider.dart';
import 'package:qr_attendance_flut/Controller/atdnc_list_provider.dart';
import 'package:qr_attendance_flut/database/database.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import 'Controller/qr_list_provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AttendanceListProvider()),
        ChangeNotifierProvider(create: (context) => QrListProvider()),
        ChangeNotifierProvider(create: (context) => AttendanceContentProvider())
      ],
      child: MaterialApp(
        title: appName,
        home: const HomePage(),
      ),
    );
  }
}
