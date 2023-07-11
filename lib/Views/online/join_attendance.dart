import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_attendance_flut/utils/ad_helper.dart';
import 'package:qr_attendance_flut/values/const.dart';

import '../../values/strings.dart';
import '../instantiable_widget.dart';

class JoinAttendance extends StatefulWidget {
  final dynamic value;
  const JoinAttendance({super.key, required this.value});

  @override
  State<JoinAttendance> createState() => _JoinAttendanceState();
}

class _JoinAttendanceState extends State<JoinAttendance> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = AdHelper.createBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController codeController = TextEditingController();
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(labelJoinAttendance),
            leadingWidth: 30,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      _submitForm(formKey, codeController);
                      Navigator.of(context).pop();
                    },
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.green)),
                    child: Text(labelJoin)),
              ),
            ],
          ),
          bottomNavigationBar:
              (_bannerAd != null) ? showAd(_bannerAd) : const SizedBox(),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(msgJoin1),
                ),
                inputField(
                    controller: codeController, label: 'Attendance Code'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(msgJoin2),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(msgJoin3),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(msgJoin4),
                ),
              ]),
            ),
          )),
    );
  }

  void _submitForm(var formKey, TextEditingController codeController) {
    if (formKey.currentState!.validate()) {
      widget.value.joinAttendance(codeController.text);
    }
  }
}
