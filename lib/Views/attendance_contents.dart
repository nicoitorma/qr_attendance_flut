import 'package:flutter/material.dart';

import '../Models/attendance.dart';

class AttendanceContents extends StatefulWidget {
  final AttendanceModel data;
  const AttendanceContents({super.key, required this.data});

  @override
  State<AttendanceContents> createState() => _AttendanceContentsState();
}

class _AttendanceContentsState extends State<AttendanceContents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.data.attendanceName!)),
    );
  }
}
