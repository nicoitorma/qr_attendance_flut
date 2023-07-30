import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/utils/file_storage.dart';

import 'package:qr_flutter/qr_flutter.dart';

class QRSaver {
  final String? idNum;
  final String? fullname;
  final String? dept;

  const QRSaver({this.idNum, this.fullname, this.dept});

  saveQRCodeToStorage() async {
    final downloadsPath =
        await FileStorage.getExternalDocumentPath('QRAttendance/QRCodes');

    final qrCode = QrCode.fromData(
        data: '$idNum&$fullname&$dept',
        errorCorrectLevel: QrErrorCorrectLevel.L);

    final painter =
        QrPainter.withQr(qr: qrCode, gapless: true, emptyColor: Colors.white);

    ByteData? byteData =
        await painter.toImageData(2040, format: ImageByteFormat.png);

    final res = await writeToFile(
        byteData!.buffer.asUint8List(), '$downloadsPath/$idNum.png');
    return res;
  }

  writeToFile(var image, String path) async {
    FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
    try {
      File file = File(path);
      file.writeAsBytes(image);
      return '$idNum is successfully saved.';
    } on PathAccessException catch (err) {
      crashlytics.log('QR SAVER: $err');
      return '$idNum failed to save: ${err.message}';
    } on PathExistsException catch (err) {
      crashlytics.log('QR SAVER: $err');
      return '$idNum failed to save: ${err.message}';
    }
  }
}
