import 'package:firebase_auth/firebase_auth.dart';

class LoginProvider {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static void signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // User is signed in
        print('Signed in as ${userCredential.user!.email}');
      }
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  // static Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;

  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  static void signOut() async {
    await _auth.signOut();

    print('Signed out');
  }
}
