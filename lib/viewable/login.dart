import 'package:flutter/material.dart';

import '../addons/buttons&fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController loginOption = TextEditingController();
  TextEditingController passControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.fromLTRB(w * 0.03, h * 0.0, w * 0.03, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.games_sharp,
                size: 120.0,
                color: Colors.white,
              ),
              const SizedBox(
                height: 12.0,
              ),
              defaultField('Email or Phone', Icons.account_circle_outlined,
                  false, loginOption, ''),
              const SizedBox(
                height: 12.0,
              ),
              otherField('Enter Password', Icons.password, true, passControl),
              loginSignUpButton(context, true, () {}),
              GoogleSignUpButton(context, Icons.abc, true, () {})
            ],
          ),
        ),
      ),
    );
  }
}
