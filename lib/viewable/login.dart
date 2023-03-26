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
    showDialog(context: context, builder: (context){
      return const Center(
        child: SpinKitDualRing(
          color: Colors.white70,
          size: 30.0,
        ),
      );
    });
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password);

      Navigator.pop(context);
    }on FirebaseAuthException catch(e){

      Navigator.pop(context);

      if(e.code == 'user-not-found'){
        showDialog(context: context, builder: (context){
          return const AlertDialog(
            title: Text('User Not Found' ),
          );
        });
        emailControl.text = '';
      }else if(e.code == 'wrong-password'){
        showDialog(context: context, builder: (context){
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

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.fromLTRB(w * 0.0, h * 0.0, w * 0.0, h * 0.01),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: w,
                height: h*0.6,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/SpecanCare.png"), fit: BoxFit.cover),),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: w*0.03, right: w*0.03),
                child: Column(
                  children: [
                    defaultField('Email', Icons.email_rounded,
                        false, emailControl, ''),
                    const SizedBox(
                      height: 12.0,
                    ),
                    otherField('Enter Password', Icons.password, true, passControl),
                    loginSignUpButton(context, true, (){
                      if(emailControl.text.isNotEmpty && passControl.text.isNotEmpty){
                        emailLogin(emailControl.text, passControl.text);
                      }else if(emailControl.text.isEmpty || passControl.text.isEmpty){

                      }
                    }),
                    GoogleSignUpButton(context, Ionicons.logo_google, true, () { Login.googleLogin().then((value){
                      Navigator.pushReplacementNamed(context, '/home');});
                    }),
                    signUpOption()
                  ],
                ),
              ),
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
            style: TextStyle(color: Colors.white70)),
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
