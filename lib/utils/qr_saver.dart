import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

void saveQRCodeToStorage(
    var context, var value, String name, String idNum, String dept) async {
  // Get the path to the directory where we want to save the image.
  Directory? downloadsDirectory;
  if (Platform.isAndroid) {
    downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
  } else if (Platform.isIOS) {
    downloadsDirectory = await getApplicationDocumentsDirectory();
  }

  String downloadsPath = '${downloadsDirectory!.path}/QRAttendance/QRCodes';

  // Create the directory if it doesn't exist
  await Directory(downloadsPath).create(recursive: true);

  // Generate QR code widget
  final qrCode = QrCode.fromData(
      data: '$idNum&$name&$dept', errorCorrectLevel: QrErrorCorrectLevel.L);

  final painter = QrPainter.withQr(
    qr: qrCode,
    color: Colors.white,
    gapless: true,
    embeddedImageStyle: null,
    embeddedImage: null,
  );
  final picData = await painter.toImageData(2048, format: ImageByteFormat.png);
  await writeToFile(picData!, '$downloadsPath/$idNum.png');

  // Show a snackbar to let the user know that the image was saved.
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('QR code saved to phone storage'),
    ),
  );
}

Future<void> writeToFile(ByteData data, String path) async {
  final buffer = data.buffer;
  await File(path)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}
