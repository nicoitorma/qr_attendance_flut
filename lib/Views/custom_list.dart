import 'package:flutter/material.dart';

Widget customAttendanceItem({var name, var details, var time, var cutoff}) =>
    Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue[200], borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.black)),
            Text(details,
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.black)),
            Text(time,
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.black)),
            Text(cutoff,
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.black))
          ],
        ),
      ),
    );
