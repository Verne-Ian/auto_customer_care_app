import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login {
  String userID;
  String passcode;

  Login({required this.userID, required this.passcode});

  static Future<UserCredential> emailLogin(String email, String password) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

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

  static get context => null;

  static Future emailSignUp(String email, String password, String displayName) async {
    try {
      // Create Firebase user account with email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set the display name for the user
      User? user = userCredential.user;
      await user?.updateDisplayName(displayName);
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog( context: context, builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Password is too weak!"),
              actions: <Widget>[
                ElevatedButton(onPressed: () {
                  Navigator.of(context).pop();
                },
                  child: const Text("OK"),
                )]);});
      } else if (e.code == 'email-already-in-use') {
        showDialog( context: context, builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("The email is Already in Use!"),
              actions: <Widget>[
                ElevatedButton(onPressed: () {
                  Navigator.of(context).pop();
                },
                  child: const Text("OK"),
                )]);});
      }
    } catch (e) {
      print('Error creating Firebase account: $e');
      // Handle error here
      showDialog( context: context, builder: (BuildContext context) {
        return AlertDialog(
            title: const Text("Invalid Email Address!"),
            actions: <Widget>[
              ElevatedButton(onPressed: () {
                Navigator.of(context).pop();
              },
                child: const Text("OK"),
              )]);});
    }
  }
}
