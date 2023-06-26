import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_attendance_flut/Repository/online_repo.dart/online_attendancelist_repo.dart';
import 'package:qr_attendance_flut/Views/drawer.dart';
import 'package:qr_attendance_flut/Views/instantiable_widget.dart';
import 'package:qr_attendance_flut/Views/join_attendance.dart';
import 'package:qr_attendance_flut/Views/offline/attendance_list/widgets.dart';
import 'package:qr_attendance_flut/values/strings.dart';

class OnlineHomepage extends StatefulWidget {
  const OnlineHomepage({super.key});

  @override
  State<OnlineHomepage> createState() => _OnlineHomepageState();
}

class _OnlineHomepageState extends State<OnlineHomepage> {
  int count = 0;
  BannerAd? _bannerAd;
  @override
  void initState() {
    super.initState();
    //_bannerAd = AdHelper.createBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(appName)),
        bottomNavigationBar:
            (_bannerAd != null) ? showAd(_bannerAd) : const SizedBox(),
        drawer: drawer(context),
        body: StreamBuilder(
            stream: OnlineAttendanceRepo().fetchAttendance(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!;
                print(data.data());
              }
              return Container();
              // return ListView.builder(itemBuilder: (context, index) {
              //   return customListItem(color: Colors.transparent);
              // });
            }),
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
                                    style:
                                        const TextStyle(color: Colors.black))),
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
            child: const Icon(Icons.add)),
      ),
    );
  }
}
