import 'dart:io';
import 'dart:typed_data';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

import 'package:qr_flutter/qr_flutter.dart';

class QRSaver extends StatefulWidget {
  final String? idNum;
  final String? fullname;
  final String? dept;

  const QRSaver({super.key, this.idNum, this.fullname, this.dept});

  @override
  State<QRSaver> createState() => _QRSaverState();
}

class _QRSaverState extends State<QRSaver> {
  final _crashlytics = FirebaseCrashlytics.instance;
  final GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      saveQRCodeToStorage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            QrImageView.withQr(
                qr: QrCode.fromData(
                    data: '${widget.idNum}&${widget.fullname}&${widget.dept}',
                    errorCorrectLevel: QrErrorCorrectLevel.L),
                backgroundColor: Colors.white),
            const Divider(),
            Text(widget.idNum!),
            Text(widget.fullname!),
            Text(widget.dept!),
          ],
        ),
      ),
    );
  }

  // getPath() async {
  void saveQRCodeToStorage() async {
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

    Uint8List imageBytes = await captureLayout();

    final image = QrImge();

    await writeToFile(imageBytes, '$downloadsPath/${widget.idNum}.png');

    // final painter =
    //     QrPainter.withQr(qr: qrCode, gapless: true, emptyColor: Colors.white);

    // const text = Text('This is a QR code',
    //     style: TextStyle(color: Color(0xFF000000), fontSize: 12));

    // final picData = await painter.toImageData(2048, format: ImageByteFormat.png);
  }

  Future<Uint8List> captureLayout() async {
    RenderRepaintBoundary? boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image? image = await boundary.toImage(
        pixelRatio: 2.0); // Increase pixelRatio for higher quality
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> writeToFile(var data, String path) async {
    await File(path).writeAsBytes(data);
    Navigator.pop(context);
  }
}
