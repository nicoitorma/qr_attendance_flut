import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
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
  final auth = FirebaseAuth.instance;
  File? image;
  final ImagePicker imagePicker = ImagePicker();
  bool uploading = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = AdHelper.createBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> uploadImage() async {
    if (image == null) {
      return;
    }

    setState(() {
      uploading = true;
    });

    try {
      final storage = FirebaseStorage.instance;
      final Reference ref =
          storage.ref().child('images/${auth.currentUser!.uid}.jpg');
      await ref.putFile(image!);
      auth.currentUser!.updatePhotoURL(await ref.getDownloadURL());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(labelSaveSuccess)),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    } finally {
      setState(() {
        uploading = false;
      });
    }
  }

  void selectImage() async {
    final img = await imagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        image = File(img.path);
      });
    }
  }

  Future<bool> reauthenticate(BuildContext context) {
    return showReauthenticateDialog(
      context: context,
      providers: [EmailAuthProvider()],
      auth: auth,
      onSignedIn: () => Navigator.of(context).pop(true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(labelProfile)),
      bottomNavigationBar:
          (_bannerAd != null) ? showAd(_bannerAd) : const SizedBox(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Stack(alignment: Alignment.center, children: [
              UserAvatar(auth: auth),
              image != null
                  ? CircleAvatar(
                      foregroundColor: Colors.white,
                      backgroundImage: FileImage(image!),
                      radius: 64,
                    )
                  : UserAvatar(auth: auth),
              Positioned(
                  bottom: -15,
                  right: 110,
                  child: IconButton(
                      onPressed: () => selectImage(),
                      icon: const Icon(Icons.add_a_photo))),
            ]),
            const SizedBox(height: 15.0),
            Center(
                child: Text('${auth.currentUser?.email}',
                    style: const TextStyle(fontSize: 16))),
            const SizedBox(height: 15.0),
            const Center(child: EditableUserDisplayName()),
            const SizedBox(height: 15.0),
            SizedBox(
              height: 45,
              child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green)),
                  onPressed: () => uploadImage(),
                  child: uploading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(labelSave)),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                  onPressed: () => auth.signOut(),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout_outlined),
                        const SizedBox(width: 8),
                        Text(labelSignout)
                      ])),
            ),
            const SizedBox(height: 8),
            DeleteAccountButton(
              auth: auth,
              onSignInRequired: () {
                return reauthenticate(context);
              },
            ),
          ]),
        ),
      ),
    );
  }
}
