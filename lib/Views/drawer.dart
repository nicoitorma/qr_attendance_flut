import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/values/strings.dart';

Widget drawer(var context) => Drawer(
    backgroundColor: Colors.blue,
    child: Column(
      children: [
        const CircleAvatar(),
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
        )
      ],
    ));
