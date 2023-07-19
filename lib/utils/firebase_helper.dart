import 'package:firebase_auth/firebase_auth.dart';

getUserEmail() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.email;
  }
  return '';
}

isOnlineMode() {
  if (FirebaseAuth.instance.currentUser != null) {
    return true;
  }
  return false;
}

getUserName() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user?.displayName != null) {
    return user?.displayName.toString();
  }
  return '';
}

hasProfileImage() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user?.photoURL != null) {
    return true;
  }
  return false;
}
