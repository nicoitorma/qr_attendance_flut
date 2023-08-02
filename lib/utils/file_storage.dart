import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// To save the file in the device
class FileStorage {
  static Future<String> getExternalDocumentPath(String dir) async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory directory = Directory('');
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      directory = Directory('/storage/emulated/0/Download/$dir');
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    try {
      await Directory(exPath).create(recursive: true);
    } catch (err) {
      FirebaseCrashlytics.instance.log(err.toString());
    }

    return exPath;
  }
}
