import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/values/strings.dart';

Widget customCard({required var icon, required String title}) => Container(
    padding: const EdgeInsets.all(5),
    height: 150,
    width: 150,
    decoration: BoxDecoration(
      color: Colors.blue[200],
      borderRadius: BorderRadius.circular(5.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 80),
        Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 16))
      ],
    ));

/// The function returns a custom attendance item widget with a name, details, time, and cutoff
/// displayed in a container with a blue background and rounded corners.
///
/// Args:
///   name: The name of the attendance item.
///   details: The details parameter is a variable that contains additional information or description
/// about the attendance item.
///   time: The time parameter is a variable that holds the time information for the attendance item. It
/// is displayed as a Text widget in the customAttendanceItem widget.
///   cutoff: The cutoff parameter is likely referring to a deadline or a specific time by which
/// something needs to be completed or submitted. It is displayed as a text in the custom attendance
/// item widget.
Widget customAttendanceItem({var name, var detail, var time, var cutoff}) =>
    Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue[200], borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (name != null)
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('$attendanceName: $name',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontSize: 18)),
                  )
                : Container(),
            (detail == null)
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('$details: $detail',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontSize: 18)),
                  ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(created + time,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 18)),
            ),
            (cutoff == null)
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(cutoffDT + cutoff,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontSize: 18)),
                  )
          ],
        ),
      ),
    );
