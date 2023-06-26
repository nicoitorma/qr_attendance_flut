import 'package:firebase_auth/firebase_auth.dart';

getUserEmail() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.email;
  }
  return '';
}
