import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../addons/buttons&fields.dart';
import '../services/MainServices.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController emailControl = TextEditingController();
  TextEditingController passControl = TextEditingController();



  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp for SpecanCare'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(w*0.1, h*0.01, w*0.1, 0.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                defaultField('Email', Icons.email, false, emailControl, ''),
                otherField('Password', Icons.password_sharp, true, passControl),
                loginSignUpButton(context, false, newUser.emailSignUp),
                GoogleSignUpButton(context, Ionicons.logo_google, true, () { Login.googleLogin().then((value){
                  Navigator.pushReplacementNamed(context, '/home');});
                }),
                haveAccountOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row haveAccountOption(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an Account?',
            style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: const Text('Login Instead',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        )
      ],
    );

  }

}
