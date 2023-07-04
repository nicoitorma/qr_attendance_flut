import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Controller/online/online_attdnc_content_prov.dart';
import 'package:qr_attendance_flut/Views/online/widget.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../../Models/attendance.dart';
import '../../values/const.dart';
import '../custom_list_tiles/attdnc_cntnt_tile.dart';

class OnlineAttendanceContents extends StatefulWidget {
  final AttendanceModel data;
  const OnlineAttendanceContents({super.key, required this.data});

  @override
  State<OnlineAttendanceContents> createState() =>
      _OnlineAttendanceContentsState();
}

class _OnlineAttendanceContentsState extends State<OnlineAttendanceContents> {
  late OnlineAttendanceContentsProv prov;
  @override
  void initState() {
    super.initState();
    prov = Provider.of<OnlineAttendanceContentsProv>(context, listen: false);
    prov.getAtndContent();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnlineAttendanceContentsProv>(
      builder: ((context, value, child) => Scaffold(
          appBar: AppBar(title: Text(widget.data.attendanceName!)),
          body: NetworkWidget(
              child: (value.list.isEmpty)
                  ? Center(child: Text(labelNoItem))
                  : ListView.builder(
                      itemCount: value.list.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: AttendanceContentTile(
                              data: value.list[index],
                              color: Colors.transparent),
                        );
                      })))),
    );
  }
}
