import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:qr_attendance_flut/Models/attendance.dart';
import 'package:qr_attendance_flut/Models/student_in_attendance.dart';
import 'package:qr_attendance_flut/Repository/offline_repo.dart/attendance_content_repo.dart';
import 'package:qr_attendance_flut/utils/firebase_helper.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../values/const.dart';
import '../values/strings.dart';

class QrScanner extends StatefulWidget {
  final AttendanceModel data;
  final dynamic provider;
  const QrScanner({super.key, required this.data, required this.provider});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isFlashOn = false;
  Color borderColor = Colors.blue;

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
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.data.attendanceName!),
            (widget.data.cutoffTimeAndDate == 'null')
                ? Container()
                : Text('$labelCutoff${widget.data.cutoffTimeAndDate} ',
                    style: subtitleStyle)
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                setState(() {
                  isFlashOn = !isFlashOn;
                });
                try {
                  // final isFlashAvail = await TorchLight.isTorchAvailable();
                  // if (isFlashAvail) {
                  controller?.toggleFlash();
                  // }
                } catch (err) {
                  debugPrint('Torch not available');
                }
              },
              child: (isFlashOn)
                  ? const Icon(Icons.flash_off_outlined)
                  : const Icon(Icons.flash_on_outlined),
            ),
          )
        ],
      ),
      body: InkWell(
        onTap: () {
          controller?.resumeCamera();
          setState(() => borderColor = Colors.blue);
        },
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderRadius: 10,
              borderColor: borderColor,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * .8),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        this.controller!.pauseCamera();
        List words = [];

        // /// This code block checks if the scanned QR code contains the character "&". If it does not
        // /// contain "&", it means that the QR code is not supported and a snackbar is shown with the
        // /// message "QR Code not supported". The return statement is used to exit the method and prevent
        // /// further processing of the QR code.
        if (!RegExp('&').hasMatch(scanData.code!)) {
          // setState(() => borderColor = Colors.red);
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //   content: Text('QR Code not supported'),
          // ));
          // return;
          words.add(scanData.code);
        } else {
          words = scanData.code!.split('&');
        }

        /// To be used in the timeAndDate the QR Scanned
        String timeAndDate =
            DateFormat(labelFullDtFormat).format(DateTime.now());

        /// To be used for checking the isLate
        DateTime timeScanned = DateFormat(labelFullDtFormat).parse(timeAndDate);
        bool isLate = false;

        /// The code block is checking if the `cutoffTimeAndDate` property of the `widget.data` object
        /// is not null. If it is not null, it then checks if the current time (`time`) is after the
        /// cutoff time specified by `widget.data.cutoffTimeAndDate`. If the current time is indeed
        /// after the cutoff time, it sets the `isLate` variable to `true`. This logic is used to
        /// determine if a student is late for attendance based on the cutoff time.
        if (widget.data.cutoffTimeAndDate != 'null') {
          if (timeScanned.isAfter(DateFormat(labelFullDtFormat)
              .parse(widget.data.cutoffTimeAndDate!))) {
            isLate = true;
          }
        }

        if (isOnlineMode()) {
          setState(() {
            borderColor = Colors.green;
            widget.provider!.insertToAttendance(StudentInAttendance(
                idNum: words[0],
                fullname: words.length >= 2 ? words[1] : '',
                dept: words.length == 3 ? words[2] : '',
                timeAndDate: timeAndDate,
                code: widget.data.attendanceCode,
                isLate: isLate.toString()));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${words[0]} is added'),
            ));
          });
        } else {
          /// This code is checking if a student with a specific ID number and attendance ID is already
          /// added to the attendance list. It does this by calling the `isAlreadyAdded` method from the
          /// `AttendanceContentRepo` class and passing in the student ID number and attendance ID as
          /// parameters.
          AttendanceContentRepo.isAlreadyAdded(words[0], widget.data.id!)
              .then((value) {
            if (value > 0) {
              setState(() {
                borderColor = Colors.red;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${words[0]} is already added')));
              return;
            }

            setState(() {
              borderColor = Colors.green;
              widget.provider!.insertToAttendance(StudentInAttendance(
                  idNum: words[0],
                  fullname: words.length >= 2 ? words[1] : '',
                  dept: words.length == 3 ? words[2] : '',
                  timeAndDate: timeAndDate,
                  attendanceId: widget.data.id,
                  isLate: isLate.toString()));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${words[0]} is added'),
              ));
            });
          });
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
