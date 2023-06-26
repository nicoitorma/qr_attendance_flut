import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Controller/online/attdnc_list_provider.dart';

import 'package:qr_attendance_flut/Views/login.dart';
import 'package:qr_attendance_flut/Views/online_homepage.dart';
import 'package:qr_attendance_flut/Views/start.dart';
import 'package:qr_attendance_flut/database/database.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import 'Controller/offline/atdnc_content_provider.dart';
import 'Controller/offline/atdnc_list_provider.dart';
import 'Controller/offline/qr_list_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'Views/offline/homepage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize the database
  await AppDatabase().initializeDB();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MobileAds.instance.initialize();
  // // Pass all uncaught "fatal" errors from the framework to Crashlytics
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
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
        ChangeNotifierProvider(
            create: (context) => AttendanceContentProvider()),
        ChangeNotifierProvider(
            create: ((context) => OnlineAttendanceListProvider()))
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
        // initialRoute: '/start',
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? '/start'
            : '/online-homepage',
        routes: {
          '/start': (context) => const StartPage(),
          '/sign-in': (context) => const Login(),
          '/homepage': (context) => const HomePage(),
          '/online-homepage': (context) => const OnlineHomepage()
        },
      ),
    );
  }
}
