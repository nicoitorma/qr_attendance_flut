import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Controller/online/online_attdnc_list_provider.dart';

import '../../values/const.dart';
import '../../values/strings.dart';
import '../custom_list_tiles/attendance_tile.dart';
import '../drawer.dart';
import '../instantiable_widget.dart';
import '../offline/attendance_contents.dart';
import '../offline/attendance_list/widgets.dart';
import 'join_attendance.dart';

class OnlineHomepage extends StatefulWidget {
  const OnlineHomepage({super.key});

  @override
  State<OnlineHomepage> createState() => _OnlineHomepageState();
}

class _OnlineHomepageState extends State<OnlineHomepage> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<OnlineAttendanceListProvider>(context, listen: false);
    provider.getAttendance();
    // TODO: DO not forget to load ads;
    //_bannerAd = AdHelper.createBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnlineAttendanceListProvider>(
        builder: (context, value, child) {
      print(value.attendanceList.map((e) => e.attendanceName));
      return Scaffold(
        appBar: (value.isLongPress)
            ? MenuAppBar(value: value)
            : AppBar(title: Text(appName)),
        bottomNavigationBar:
            (_bannerAd != null) ? showAd(_bannerAd) : const SizedBox(),
        drawer: drawer(context),
        body: (value.attendanceList.isEmpty)
            ? Center(child: Text(labelNoItem))
            : ListView.builder(
                key: ValueKey(value.attendanceList.length),
                itemCount: value.attendanceList.length,
                itemBuilder: (context, index) {
                  var data = value.attendanceList[index];

                  print('UI: ${value.attendanceList.length}');
                  return AttendanceTile(
                    data: data,
                    color: (value.selectedTile.contains(data))
                        ? Colors.red
                        : Colors.transparent,
                    onTap: () {
                      if (value.isLongPress) {
                        if (value.selectedTile
                            .contains(value.attendanceList[index])) {
                          value.removeItemFromSelected(
                              value.attendanceList[index]);
                          if (value.selectedTile.isEmpty) {
                            value.setLongPress();
                          }
                        } else {
                          value.selectTile(value.attendanceList[index]);
                        }
                        return;
                      }
                      Navigator.of(context).push(PageTransition(
                          type: PageTransitionType.rightToLeftJoined,
                          child: AttendanceContents(
                              data: value.attendanceList[index]),
                          duration: transitionDuration,
                          reverseDuration: transitionDuration,
                          childCurrent: widget));
                    },
                    onLongPress: () {
                      value.setLongPress();
                      value.selectTile(value.attendanceList[index]);
                    },
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (_) => SizedBox(
                    height: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: TextButton(

                              /// This code is defining the action to be taken when the
                              /// FloatingActionButton is pressed. It opens a modal bottom sheet with
                              /// two options: "Create Attendance" and "Join Attendance". When the
                              /// "Create Attendance" option is pressed, it replaces the current page
                              /// with the CreateAttendancePopup page using the Navigator class. The
                              /// `pushReplacement` method replaces the current page with the new
                              /// page, instead of adding it to the navigation stack.
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            const CreateAttendancePopup()));
                              },
                              child: Text(labelCreateAttendance,
                                  style: const TextStyle(color: Colors.black))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 3),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            const JoinAttendance()));
                              },
                              child: Text(
                                labelJoinAttendance,
                                style: const TextStyle(color: Colors.black),
                              )),
                        )
                      ],
                    )));
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
