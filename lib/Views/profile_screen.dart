import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/values/strings.dart';

class CustomProfileScreen extends StatelessWidget {
  const CustomProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    Future<bool> _reauthenticate(BuildContext context) {
      return showReauthenticateDialog(
        context: context,
        providers: [EmailAuthProvider()],
        auth: auth,
        onSignedIn: () => Navigator.of(context).pop(true),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(labelProfile)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const UserAvatar(),
              const SizedBox(
                height: 15.0,
              ),
              const Center(child: EditableUserDisplayName()),
              const SizedBox(
                height: 15.0,
              ),
              SignOutButton(
                auth: auth,
                variant: ButtonVariant.outlined,
              ),
              const SizedBox(height: 8),
              DeleteAccountButton(
                auth: auth,
                onSignInRequired: () {
                  return _reauthenticate(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
