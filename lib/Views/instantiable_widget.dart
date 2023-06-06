import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Models/attendance.dart';

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
    {required Color color,
    required AttendanceModel attendanceData,
    Function()? onTap,
    Function()? onLongPress}) {
  return Card(
    color: Colors.blue[200],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 5,
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: ListTile(
          onTap: onTap,
          onLongPress: onLongPress,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0),
            child: Text(
              attendanceData.attendanceName!,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0),
                child: Text(attendanceData.details ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0),
                child: Text(attendanceData.dateTime ?? ''),
              )
            ],
          )),
    ),
  );
}
