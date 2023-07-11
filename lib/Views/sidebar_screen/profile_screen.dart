import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_attendance_flut/utils/ad_helper.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../instantiable_widget.dart';

class CustomProfileScreen extends StatefulWidget {
  const CustomProfileScreen({super.key});

  @override
  State<CustomProfileScreen> createState() => _CustomProfileScreenState();
}

class _CustomProfileScreenState extends State<CustomProfileScreen> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = AdHelper.createBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    Future<bool> reauthenticate(BuildContext context) {
      return showReauthenticateDialog(
        context: context,
        providers: [EmailAuthProvider()],
        auth: auth,
        onSignedIn: () => Navigator.of(context).pop(true),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(labelProfile)),
      bottomNavigationBar:
          (_bannerAd != null) ? showAd(_bannerAd) : const SizedBox(),
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
                  return reauthenticate(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
