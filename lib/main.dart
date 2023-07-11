import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Controller/online/online_attdnc_content_prov.dart';
import 'package:qr_attendance_flut/Controller/online/online_attdnc_list_provider.dart';

import 'package:qr_attendance_flut/Views/online/login.dart';
import 'package:qr_attendance_flut/Views/online/online_homepage.dart';
import 'package:qr_attendance_flut/Views/start.dart';
import 'package:qr_attendance_flut/database/database.dart';
import 'package:qr_attendance_flut/utils/connectivity.dart';
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

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AttendanceListProvider()),
        ChangeNotifierProvider(create: (_) => QrListProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceContentProvider()),
        StreamProvider<ConnectionStatus>.value(
          initialData: ConnectionStatus.offline,
          value: ConnectivityService().connectivityController.stream,
        ),
        ChangeNotifierProvider(create: (_) => OnlineAttendanceListProvider()),
        ChangeNotifierProvider(create: (_) => OnlineAttendanceContentsProv())
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
