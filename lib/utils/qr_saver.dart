import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qr_flutter/qr_flutter.dart';

class QRSaver {
  final String? idNum;
  final String? fullname;
  final String? dept;

  const QRSaver({this.idNum, this.fullname, this.dept});

  saveQRCodeToStorage() async {
    // Get the path to the directory where we want to save the image.
    Directory? downloadsDirectory;
    if (Platform.isAndroid) {
      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    } else if (Platform.isIOS) {
      downloadsDirectory = await getApplicationDocumentsDirectory();
    }

    String downloadsPath = '${downloadsDirectory?.path}/QRAttendance/QRCodes';

    // Create the directory if it doesn't exist
    await Directory(downloadsPath).create(recursive: true);

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
      await File(path).writeAsBytes(image);
      return '$idNum is successfully saved.';
    } catch (err) {
      crashlytics.log('QR SAVER: $err');
      return '$idNum failed to save: $err';
    }
  }
}
