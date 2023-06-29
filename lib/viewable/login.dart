import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../addons/buttons&fields.dart';
import '../services/MainServices.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailControl = TextEditingController();
  TextEditingController passControl = TextEditingController();



  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: w),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.fromLTRB(w * 0.0, h * 0.15, w * 0.0, h * 0.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: w * 0.3,
                        height: w * 0.3,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              opacity: 0.9,
                              image: AssetImage("assets/images/hospital.png"),
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 10.0,),
                      SizedBox(
                        width: w*0.3,
                        child: Text(
                          "M & S General Clinic",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              height: 0.8,
                              color: Colors.black54, fontSize: w * 0.065, fontFamily: 'DancingScript'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: w * 0.03, right: w * 0.03),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Login",
                            style:
                                TextStyle(color: Colors.black54, fontSize: w * 0.09, fontFamily: 'DancingScript'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          otherField('Email', Icons.email_rounded, false,
                              emailControl),
                          const SizedBox(
                            height: 12.0,
                          ),
                          otherField('Enter Password', Icons.password, true,
                              passControl),
                          const SizedBox(
                            height: 8.0,
                          ),
                          loginSignUpButton(context, true, () {
                              if (_formKey.currentState!.validate()) {
                                Login.emailLogin(emailControl, passControl, emailControl.text, passControl.text, context);
                              }
                          }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(
                                child: Divider(
                                  color: Colors.black,
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
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.black,
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
                          signUpOption(),
                          const SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
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
        const Text('First time here?', style: TextStyle(color: Colors.black54)),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/sign');
          },
          child: const Text(
            'Create Account',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
