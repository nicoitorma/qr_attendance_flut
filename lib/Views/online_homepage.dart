import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Repository/online_attendancelist_repo.dart';
import 'package:qr_attendance_flut/Views/drawer.dart';
import 'package:qr_attendance_flut/values/strings.dart';

class OnlineHomepage extends StatefulWidget {
  const OnlineHomepage({super.key});

  @override
  State<OnlineHomepage> createState() => _OnlineHomepageState();
}

class _OnlineHomepageState extends State<OnlineHomepage> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(appName)),
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
