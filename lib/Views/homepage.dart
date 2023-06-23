import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_attendance_flut/Views/qr_list.dart';
import 'package:qr_attendance_flut/Views/instantiable_widget.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../values/const.dart';
import 'attendance_list/attendance_list.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(appName)),
        drawer: drawer(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// This code is creating an InkWell widget that has a customCard widget as its
                /// child. When the InkWell is tapped, it navigates to the AttendanceList page using
                /// the Navigator widget. The MaterialPageRoute is used to define the route to the
                /// AttendanceList page. The const keyword is used to create a constant instance of
                /// the AttendanceList widget.
                InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => const AttendanceList())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.maxFinite,
                      child: customCard(
                          icon: Icons.description_outlined,
                          title: labelAttendanceList),
                    )),

                const Padding(
                    padding: EdgeInsets.all(10),
                    child: Divider(thickness: 3, height: 50)),

                /// This code is creating an InkWell widget that has a customCard widget as its child.
                /// When the InkWell is tapped, it navigates to the QrCodeList page using the Navigator
                /// widget and a page transition animation defined by the PageTransition package. The
                /// const keyword is used to create a constant instance of the QrCodeList widget. The
                /// customCard widget displays an icon and a title.
                InkWell(
                    onTap: () => Navigator.of(context).push(PageTransition(
                        type: PageTransitionType.rightToLeftJoined,
                        child: const QrCodeList(),
                        duration: transitionDuration,
                        reverseDuration: transitionDuration,
                        childCurrent: widget)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.maxFinite,
                      child: customCard(
                          icon: Icons.qr_code_2_outlined, title: labelQrCodes),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
