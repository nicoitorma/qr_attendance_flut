import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:qr_attendance_flut/Views/online/online_homepage.dart';

import '../../values/strings.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final providers = [EmailAuthProvider()];
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  static Future<User?> signUp(
      {required String userEmail,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: userEmail, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The account already exists for that email.')));
      } else {
        print(e);
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (auth.currentUser!.emailVerified) {
                return const OnlineHomepage();
              }
            }

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
                AuthStateChangeAction<UserCreated>((context, state) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const EmailVerificationScreen()));
                }),
                AuthStateChangeAction<SignedIn>((context, state) {
                  if (auth.currentUser!.emailVerified) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OnlineHomepage()),
                    );
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const EmailVerificationScreen()));
                  }
                }),
              ],
            );
          }),
    );
  }
}
