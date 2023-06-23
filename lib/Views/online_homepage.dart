import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Views/instantiable_widget.dart';
import 'package:qr_attendance_flut/values/strings.dart';

class OnlineHomepage extends StatefulWidget {
  const OnlineHomepage({super.key});

  @override
  State<OnlineHomepage> createState() => _OnlineHomepageState();
}

class _OnlineHomepageState extends State<OnlineHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appName)),
      body: StreamBuilder(
          builder: (context, snapshot) =>
              ListView.builder(itemBuilder: (context, index) {
                return customListItem(color: Colors.transparent);
              })),
      floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
    );
  }
}
