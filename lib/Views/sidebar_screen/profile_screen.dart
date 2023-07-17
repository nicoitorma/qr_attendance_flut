import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_attendance_flut/utils/ad_helper.dart';
import 'package:qr_attendance_flut/utils/image_picker.dart';
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
    Uint8List? image;

    Future<bool> reauthenticate(BuildContext context) {
      return showReauthenticateDialog(
        context: context,
        providers: [EmailAuthProvider()],
        auth: auth,
        onSignedIn: () => Navigator.of(context).pop(true),
      );
    }

    void selectImage() async {
      Uint8List img = await pickImage(ImageSource.gallery);
      setState(() {
        image = img;
      });
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
              Stack(alignment: Alignment.center, children: [
                image == null
                    ? const CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                            'https://static.vecteezy.com/system/resources/previews/021/548/095/original/default-profile-picture-avatar-user-avatar-icon-person-icon-head-icon-profile-picture-icons-default-anonymous-user-male-and-female-businessman-photo-placeholder-social-network-avatar-portrait-free-vector.jpg'))
                    : CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.white,
                        backgroundImage: MemoryImage(image!)),
                Positioned(
                    bottom: -10,
                    right: 110,
                    child: IconButton(
                        onPressed: () => selectImage(),
                        icon: const Icon(Icons.add_a_photo)))
              ]),
              const SizedBox(height: 15.0),
              Center(
                  child: Text('${auth.currentUser?.email}',
                      style: const TextStyle(fontSize: 16))),
              const SizedBox(height: 15.0),
              const Center(child: EditableUserDisplayName()),
              const SizedBox(height: 15.0),
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
