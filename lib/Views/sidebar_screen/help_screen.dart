import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_attendance_flut/utils/ad_helper.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../instantiable_widget.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = AdHelper.createBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(labelHelp)),
        bottomNavigationBar:
            (_bannerAd != null) ? showAd(_bannerAd) : const SizedBox(),
        body: const SingleChildScrollView(
          child: Column(children: [
            Padding(padding: EdgeInsets.all(16.0), child: HtmlWidget('''
            <h2>Overview</h2>
            <p>In the QR Attendance app, QR codes play a crucial role in tracking attendance for school events and class.</p>
            <h2>Online Mode Attendance:</h2>
            <p>1. The administrator has the ability to include a participant in the attendance by providing them with a code. Once the participant has the code, they can scan a QR Code that will be added to the shared attendance record. </p>
            <p>2. Only the attendance administrator will have access to the full attendance contents, including the list of attendees who have scanned the QR code.</p>
            <p>3. Other participants will only see the QR code that they have scanned. This ensures privacy and prevents unauthorized access to attendance records.</p>
            
            <h2>Exporting Attendance:</h2>
            <p>The contents of the attendance can be exported to an <b>Excel file</b>. The exported excel file can be found in the Downloads then in the <b>"Attendances"</b> folder of the phone's storage.</p> 
            <p>Scanned QR codes which are past the set Cutoff time in the attendance would have a <a style="background-color: #ed344a; color:#FFFFFF">red</a> background color in its Date and Time Scanned field in the excel file.</p>
            <b>For online attendances:</b>
            <p>The administrator of the attendance can export the entire contents of the attendance, but participants can only export the QR codes they scanned.</p>
            
            <h2>QR Codes:</h2>
            <p>The QR Codes accepted by the app are either those generated by the app itself or those that adhere to the format of <b>ID Number&Fullname&Department</b>. The QR Codes can be created in <b>Offline Mode</b>, which can be saved to phone storage in the <b>Downloads</b> inside the <b>QRCodes</b> folder.</p>
            ''')),
          ]),
        ));
  }
}
