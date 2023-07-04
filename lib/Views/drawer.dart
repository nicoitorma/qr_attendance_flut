import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/values/strings.dart';

Widget drawer(var context) => Drawer(
    backgroundColor: Colors.blue,
    child: Column(
      children: [
        Image.asset(
          'assets/images/dev.png',
          height: 130,
        ),
        const Divider(thickness: 3),
        ListTile(
          selectedColor: Colors.grey,
          textColor: Colors.white,
          iconColor: Colors.white,
          title: Text(labelHelp),
          leading: const Icon(Icons.help_outline_rounded),
          onTap: () {
            Navigator.pop(context);
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
