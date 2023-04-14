import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login {
  String userID;
  String passcode;

  Login({required this.userID, required this.passcode});

  static phoneLogin(String phone) {
    return FirebaseAuth.instance.signInWithPhoneNumber(phone);
  }

  static Future<User?> googleLogin() async {
    if (kIsWeb) {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Trigger the authentication flow
      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(googleProvider);

        // Return the user object
        return userCredential.user;
      } catch (e) {
        print(e.toString());
        return null;
      }
    } else {
      //beginning the sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      //Obataining the Authentication details from the Google sign in Request
      final GoogleSignInAuthentication? gAuth = await gUser?.authentication;

      //Creates a new credential for the user
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth?.accessToken, idToken: gAuth?.idToken);

      //This will sign in the user
      final appUser =
      await FirebaseAuth.instance.signInWithCredential(credential);
      return appUser.user;
  }
  }
}

class newUser {
  String email;
  String password;
  String phone;
  String displayName;

  newUser(
      {required this.email,
      required this.password,
      required this.phone,
      required this.displayName});
}
