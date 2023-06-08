import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Controller/atdnc_content_provider.dart';
import 'package:qr_attendance_flut/Models/attendance.dart';
import 'package:qr_attendance_flut/Models/student_in_attendance.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../values/strings.dart';

class QrScanner extends StatefulWidget {
  final AttendanceModel data;
  const QrScanner({super.key, required this.data});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isFlashOn = false;
  AttendanceContentProvider? provider;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceContentProvider>(
        builder: (context, value, child) {
      provider = value;
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.data.attendanceName!),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isFlashOn = !isFlashOn;
                  });
                  controller?.toggleFlash();
                },
                child: (isFlashOn)
                    ? const Icon(Icons.flash_off_outlined)
                    : const Icon(Icons.flash_on_outlined),
              ),
            )
          ],
        ),
        body: InkWell(
          onTap: () => controller?.resumeCamera(),
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
                borderRadius: 10,
                borderColor: Colors.blue,
                borderWidth: 5,
                cutOutSize: MediaQuery.of(context).size.width * .8),
          ),
        ),
      );
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        this.controller!.pauseCamera();
        String timeAndDate =
            DateFormat(labelDateFormat).format(DateTime.now()).toString();

        setState(() {
          List words = scanData.code!.split('&');
          provider!.insertToAttendance(StudentInAttendance(
              idNum: words[0],
              fullname: words[1],
              dept: words[2],
              parentId: widget.data.id,
              timeAndDate: timeAndDate,
              isLate: false));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${words[1]} is added'),
          ));
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
