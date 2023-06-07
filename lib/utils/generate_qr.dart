import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Future<String> qrCodeToBase64(String data, {int size = 200}) async {
  // Generate the QR code image

  // Create a `RepaintBoundary` to capture the QR code as an image
  final boundary = GlobalKey();

  // Render the QR code image
  final renderObject =
      boundary.currentContext?.findRenderObject() as RenderRepaintBoundary;
  final image = await renderObject.toImage();

  // Convert the image to byte data
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  final bytes = byteData!.buffer.asUint8List();

  // Encode the byte data to base64
  final base64String = base64Encode(bytes);

  return base64String;
}
