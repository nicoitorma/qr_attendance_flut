import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_attendance_flut/Repository/online_attendancelist_repo.dart';
import 'package:qr_attendance_flut/Views/drawer.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../utils/ad_helper.dart';

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
    _bannerAd = AdHelper.createBannerAd();
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
        bottomNavigationBar: (_bannerAd != null)
            ? SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!))
            : const SizedBox(),
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
              OnlineAttendanceRepo().createAttendance(count: count);
              count++;
            },
            child: const Icon(Icons.add)),
      ),
    );
  }
}
