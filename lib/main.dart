import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Controller/atdnc_content_provider.dart';
import 'package:qr_attendance_flut/Controller/atdnc_list_provider.dart';
import 'package:qr_attendance_flut/Views/homepage.dart';
import 'package:qr_attendance_flut/Views/login.dart';
import 'package:qr_attendance_flut/Views/start.dart';
import 'package:qr_attendance_flut/database/database.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import 'Controller/qr_list_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize the database
  await AppDatabase().initializeDB();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        theme: ThemeData(
          fontFamily: 'Poppins',
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(20),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
        ),
        title: appName,
        initialRoute: '/start',
        // initialRoute: FirebaseAuth.instance.currentUser == null
        //     ? '/sign-in'
        //     : '/homepage',
        routes: {
          '/start': (context) => const StartPage(),
          '/sign-in': (context) => const Login(),
          '/homepage': (context) => const HomePage()
        },
      ),
    );
  }
}
