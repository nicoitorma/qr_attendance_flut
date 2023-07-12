import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Controller/online/online_attdnc_list_provider.dart';
import 'package:qr_attendance_flut/Views/drawer.dart';
import 'package:qr_attendance_flut/Views/online/attendance_content.dart';
import 'package:qr_attendance_flut/Views/online/network_widget.dart';

import '../../utils/ad_helper.dart';
import '../../values/const.dart';
import '../../values/strings.dart';
import '../custom_list_tiles/attendance_tile.dart';
import '../instantiable_widget.dart';
import '../menu_app_bar.dart';
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

    // TODO: DO not forget to load ads;
    _bannerAd = AdHelper.createBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<OnlineAttendanceListProvider>(context, listen: false);
    provider.getAttendance();
    return Consumer<OnlineAttendanceListProvider>(
        builder: (context, value, child) => SafeArea(
                child: Scaffold(
              drawer: drawer(context),
              bottomNavigationBar:
                  (_bannerAd != null) ? showAd(_bannerAd) : const SizedBox(),
              appBar: (value.isLongPress)
                  ? MenuAppBar(value: value)
                  : AppBar(title: Text(labelAttendanceList)),
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
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 10),
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
                                                    CreateAttendancePopup(
                                                        provider: value)));
                                      },
                                      child: Text(labelCreateAttendance,
                                          style: const TextStyle(
                                              color: Colors.black))),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 3),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    JoinAttendance(
                                                        value: value)));
                                      },
                                      child: Text(
                                        labelJoinAttendance,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      )),
                                )
                              ],
                            )));
                  },
                  child: const Icon(Icons.add)),
              body: NetworkWidget(
                child: (value.list.isEmpty)
                    ? Center(
                        child: Text(labelNoItem),
                      )
                    : ListView.builder(
                        itemCount: value.list.length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: AttendanceTile(
                              data: value.list[index],
                              color:
                                  value.selectedTile.contains(value.list[index])
                                      ? Colors.red
                                      : Colors.transparent,
                              onTap: () {
                                if (value.isLongPress) {
                                  if (value.selectedTile
                                      .contains(value.list[index])) {
                                    value.removeItemFromSelected(
                                        value.list[index]);
                                    if (value.selectedTile.isEmpty) {
                                      value.setLongPress();
                                    }
                                  } else {
                                    value.selectTile(value.list[index]);
                                  }
                                  return;
                                }
                                Navigator.of(context).push(PageTransition(
                                    type: PageTransitionType.rightToLeftJoined,
                                    child: OnlineAttendanceContents(
                                        data: value.list[index]),
                                    duration: transitionDuration,
                                    reverseDuration: transitionDuration,
                                    childCurrent: widget));
                              },
                              onLongPress: () {
                                value.setLongPress();
                                value.selectTile(value.list[index]);
                              },
                            ),
                          );
                        })),
              ),
            )));
  }
}
