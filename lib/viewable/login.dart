import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';

import '../addons/buttons&fields.dart';
import '../services/MainServices.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailControl = TextEditingController();
  TextEditingController passControl = TextEditingController();

  void emailLogin(String email, String password) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: SpinKitDualRing(
              color: Colors.white70,
              size: 30.0,
            ),
          );
        });
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => Navigator.pop(context));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('User Not Found'),
              );
            });
        emailControl.text = '';
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('Wrong Password'),
              );
            });
        passControl.text = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: w * 1.0),
        child: Scaffold(
          backgroundColor: Colors.blueGrey[900],
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.fromLTRB(w * 0.0, 0.0, w * 0.0, h * 0.01),
              child: Column(
                children: [
                  Container(
                    width: w,
                    height: h * 0.5,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          opacity: 0.9,
                          image: AssetImage("assets/images/SpenCare.png"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: w * 0.03, right: w * 0.03),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          width: 240,
                          height: 70.0,
                          child: Text(
                            "Hello there, Welcome to SpenCare Support App Please Log In to use our services",
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultField('Email', Icons.email_rounded, false,
                            emailControl, ''),
                        const SizedBox(
                          height: 12.0,
                        ),
                        otherField('Enter Password', Icons.password, true,
                            passControl),
                        const SizedBox(
                          height: 8.0,
                        ),
                        loginSignUpButton(context, true, () {
                          if (emailControl.text.isNotEmpty &&
                              passControl.text.isNotEmpty) {
                            emailLogin(emailControl.text, passControl.text);
                          } else if (emailControl.text.isEmpty ||
                              passControl.text.isEmpty) {}
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Expanded(
                              child: Divider(
                                color: Colors.white,
                                height: 5.0,
                                thickness: 2.0,
                                indent: 15.0,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            SizedBox(
                              width: 30.0,
                              child: Text(
                                "OR",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.white,
                                height: 5.0,
                                thickness: 2.0,
                                endIndent: 15.0,
                              ),
                            ),
                          ],
                        ),
                        GoogleSignUpButton(context, Ionicons.logo_google, true,
                            () {
                          Login.googleLogin();
                        }),
                        signUpOption()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('First time here?', style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/sign');
          },
          child: const Text(
            'Create Account',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
