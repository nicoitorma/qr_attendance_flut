import 'package:flutter/material.dart';

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
Widget customAttendanceItem(
        {bool? isSelected,
        required String name,
        String? detail,
        String? time}) =>
    Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: (isSelected != null) ? Colors.black : Colors.blue[200]!,
                width: 2),
            color: Colors.blue[200],
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 8.0, right: 8.0, bottom: 10.0),
              child: Text(name,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 18)),
            ),
            Container(
              padding: detail == null
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Text(detail ?? '',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 18)),
            ),
            Padding(
              padding: detail == null
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Text(time ?? '',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 18)),
            ),
          ],
        ),
      ),
    );
