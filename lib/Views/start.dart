import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_attendance_flut/Views/instantiable_widget.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../utils/ad_helper.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = AdHelper.createBannerAd();
    checkPermission(context);
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  checkPermission(var context) async {
    FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
    try {
      // Check if the storage permission has already been granted.
      if (await Permission.storage.isGranted) {
        // Permission has already been granted, so do nothing.
      } else {
        // Permission has not been granted, so request it.
        PermissionStatus status = await Permission.storage.request();

        // Check the status of the permission request.
        if (status.isGranted) {
          // Permission has been granted.
        } else if (status.isDenied) {
          // Permission has been denied, so show a dialog to the user.
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Storage permission required'),
                content: const Text(
                    'This app needs access to your storage to work properly.'),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Settings'),
                    onPressed: () {
                      // Navigate to the app settings screen so the user can grant the permission.
                      openAppSettings();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (err) {
      crashlytics.log('PERMISSION: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          (_bannerAd != null) ? showAd(_bannerAd) : const SizedBox(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 80),
              child: Text(
                labelWelcome,
                style: const TextStyle(fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: InkWell(
                onTap: () => _showModalBottom(
                    context, labelOnlineMode, msgOnlineAttendance, msgQr),
                child: Card(
                    elevation: 10,
                    color: Colors.blue[400],
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        labelOnlineMode,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: InkWell(
                onTap: () => _showModalBottom(
                    context, labelOfflineMode, msgOfflineAttendance, msgQr),
                child: Card(
                    elevation: 10,
                    color: Colors.blue[400],
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        labelOfflineMode,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  _showModalBottom(var context, String title, String msg1, String msg2) {
    return showModalBottomSheet(
        context: context,
        builder: (_) => Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Text(labelOnAttendance,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(msg1),
                  (title == labelOnlineMode)
                      ? Container()
                      : Text(labelQrCodes,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                  (title == labelOnlineMode) ? Container() : Text(msg2),
                  Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          onPressed: () {
                            if (title == labelOnlineMode &&
                                FirebaseAuth.instance.currentUser == null) {
                              Navigator.pushReplacementNamed(
                                  context, '/sign-in');
                            } else if (title == labelOnlineMode &&
                                FirebaseAuth.instance.currentUser != null) {
                              Navigator.pushReplacementNamed(
                                  context, '/online-homepage');
                            } else {
                              Navigator.pushReplacementNamed(
                                  context, '/homepage');
                            }
                          },
                          child: Text(
                            labelProceed,
                            style: const TextStyle(fontSize: 18),
                          )))
                ],
              ),
            ));
  }
}
