import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    print('IMAGE');
    return await file.readAsBytes();
  } else {
    crashlytics.log('PROFILE: No image selected');
  }
}
