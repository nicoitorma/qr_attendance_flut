import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:qr_attendance_flut/Views/online/online_homepage.dart';
import 'package:qr_attendance_flut/values/strings.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final providers = [EmailAuthProvider()];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SignInScreen(
              providers: providers,
              headerBuilder: (context, constraints, shrinkOffset) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 40, 30, 10),
                  child:
                      Text(labelWelcome, style: const TextStyle(fontSize: 30)),
                );
              },
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OnlineHomepage()),
                  );
                }),
              ],
            );
          }
          return const OnlineHomepage();
        });
  }
}
