import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Views/sidebar_screen/privacy_policy.dart';
import 'package:qr_attendance_flut/Views/sidebar_screen/profile_screen.dart';
import 'package:qr_attendance_flut/utils/firebase_helper.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import 'sidebar_screen/about_screen.dart';
import 'sidebar_screen/help_screen.dart';

Widget drawer(var context) => Drawer(
    backgroundColor: Colors.blue,
    child: Column(
      children: [
        Image.asset(
          'assets/images/dev.png',
          height: 130,
        ),
        (getUserName() == 'null')
            ? const Text('')
            : Text(
                getUserName(),
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
        const Divider(thickness: 3),
        isOnlineMode()
            ? ListTile(
                selectedColor: Colors.grey,
                textColor: Colors.white,
                iconColor: Colors.white,
                title: Text(labelProfile),
                leading: const Icon(Icons.person_2_outlined),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const CustomProfileScreen()));
                },
              )
            : Container(),
        ListTile(
          selectedColor: Colors.grey,
          textColor: Colors.white,
          iconColor: Colors.white,
          title: Text(labelHelp),
          leading: const Icon(Icons.help_outline_rounded),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const HelpScreen()));
          },
        ),
        ListTile(
          selectedColor: Colors.grey,
          textColor: Colors.white,
          iconColor: Colors.white,
          title: Text(labelPrivPol),
          leading: const Icon(Icons.privacy_tip_outlined),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicy()));
          },
        ),
        ListTile(
          selectedColor: Colors.grey,
          textColor: Colors.white,
          iconColor: Colors.white,
          title: Text(labelAbout),
          leading: const Icon(Icons.info_outline_rounded),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AboutScreen()));
          },
        ),
        FirebaseAuth.instance.currentUser != null
            ? ListTile(
                selectedColor: Colors.grey,
                textColor: Colors.white,
                iconColor: Colors.white,
                title: Text(labelSignout),
                leading: const Icon(Icons.logout_outlined),
                onTap: () {
                  FirebaseUIAuth.signOut();
                  Navigator.pushReplacementNamed(context, '/start');
                },
              )
            : ListTile(
                selectedColor: Colors.grey,
                textColor: Colors.white,
                iconColor: Colors.white,
                title: Text(labelExit),
                leading: const Icon(Icons.logout_outlined),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/start');
                },
              )
      ],
    ));
