import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Login {
  String userID;
  String passcode;

  Login({required this.userID, required this.passcode});

  static phoneLogin(String phone) {
    return FirebaseAuth.instance.signInWithPhoneNumber(phone);
  }

  static googleLogin() {
    return FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());
  }
}

class newUser {
  String email;
  String password;
  String phone;
  String displayName;
  

  newUser({
    required this.email,
    required this.password,
    required this.phone,
    required this.displayName});
}
