import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Views/instantiable_widget.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import 'attendance_list.dart';
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
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (builder) => const AttendanceList())),
                        child: customCard(
                            icon: Icons.description_outlined,
                            title: attendanceList)),
                    GestureDetector(
                      child: customCard(
                          icon: Icons.qr_code_2_outlined,
                          title: 'Create QR Code'),
                    )
                  ],
                ),
                const Divider(thickness: 3, height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        child: customCard(
                            icon: Icons.qr_code_scanner_outlined,
                            title: 'Check QR Code')),
                    customCard(icon: Icons.storage_outlined, title: genQr)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
