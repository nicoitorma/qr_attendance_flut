import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Controller/atdnc_content_provider.dart';
import 'package:qr_attendance_flut/Views/instantiable_widget.dart';
import 'package:qr_attendance_flut/utils/qr_scanner.dart';

import '../Models/attendance.dart';
import '../values/const.dart';

class AttendanceContents extends StatefulWidget {
  final AttendanceModel data;
  const AttendanceContents({super.key, required this.data});

  @override
  State<AttendanceContents> createState() => _AttendanceContentsState();
}

class _AttendanceContentsState extends State<AttendanceContents> {
  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<AttendanceContentProvider>(context, listen: false);
    provider.getAtndContent();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceContentProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.data.attendanceName!)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(PageTransition(
                type: PageTransitionType.fade,
                child: QrScanner(data: widget.data),
                duration: transitionDuration,
                reverseDuration: transitionDuration,
                childCurrent: widget));
          },
          child: const Icon(Icons.qr_code_scanner_outlined),
        ),
        body: ListView.builder(
            itemCount: value.content.length,
            itemBuilder: (context, index) {
              return customListItem(
                  color: Colors.transparent, data: value.content[index]);
            }),
      ),
    );
  }
}
