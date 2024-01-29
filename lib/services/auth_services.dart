import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/home_screen.dart';

class AuthServices {
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return null;
    }

    try {
      final GoogleSignInAuthentication userAuthentication =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: userAuthentication.accessToken,
        idToken: userAuthentication.idToken,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        barrierDismissible: false, // Prevent dismissing the dialog
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.of(context).pop();
      Get.off(() => HomeScreen());
      return userCredential;
    } catch (error) {
      // Handle errors, e.g., display an error message
      print("Error signing in with Google: $error");
      return null;
    }
  }
}
