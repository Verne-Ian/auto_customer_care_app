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
  TextEditingController emailControl = TextEditingController();
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
              defaultField('Email', Icons.email_rounded,
                  false, emailControl, ''),
              const SizedBox(
                height: 12.0,
              ),
              otherField('Enter Password', Icons.password, true, passControl),
              loginSignUpButton(context, true, (){
                if(emailControl.text.isNotEmpty && passControl.text.isNotEmpty){
                  Login.emailLogin(emailControl.text, passControl.text).then((value){
                    Navigator.pushReplacementNamed(context, '/home');});
                }else{

                }
              }),
              GoogleSignUpButton(context, Ionicons.logo_google, true, () { Login.googleLogin().then((value){
                Navigator.pushReplacementNamed(context, '/home');});
              }),
              signUpOption()
            ],
          ),
        ),
      ),
    );
  }

  Row signUpOption(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('First time here?',
            style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/sign');
          },
          child: const Text('Create Account',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        )
      ],
    );

  }

}
