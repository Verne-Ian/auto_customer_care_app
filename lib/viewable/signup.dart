import 'package:firebase_auth/firebase_auth.dart';
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

  TextEditingController nameControl = TextEditingController();
  TextEditingController emailControl = TextEditingController();
  TextEditingController passControl = TextEditingController();

  Future emailSignUp(String email, String password, String displayName) async {
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



  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: w*1.0),
        child: Scaffold(
          backgroundColor: Colors.blueGrey[900],
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(w*0.0, h*0.01, w*0.0, h * 0.01),
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
                  Padding(
                    padding: EdgeInsets.only(left: w * 0.03, right: w * 0.03),
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        const SizedBox(
                          width: 240,
                          height: 70.0,
                          child: Text(
                            "Welcome to SpenCare Support App, Create an Account with us and enjoy our Services.",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15.0),),
                        ),
                        defaultField('Preferred Name', Ionicons.person, false, nameControl, ''),
                        const SizedBox(height: 10.0,),
                        defaultField('Email', Icons.email, false, emailControl, ''),
                        const SizedBox(height: 10.0,),
                        otherField('Password', Icons.password_sharp, true, passControl),
                        loginSignUpButton(context, false, () async {await emailSignUp(emailControl.text, passControl.text, nameControl.text).then((value) => Navigator.pushReplacementNamed(context, '/home'));}),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Expanded(
                              child: Divider(
                                color: Colors.white70,
                                height: 5.0,
                                thickness: 2.0,
                                indent: 15.0,
                              ),
                            ),
                            SizedBox(width: 10.0,),
                            SizedBox(width: 30.0,
                              child: Text(
                                "OR",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),),),
                            Expanded(
                              child: Divider(
                                color: Colors.white70,
                                height: 5.0,
                                thickness: 2.0,
                                endIndent: 15.0,
                              ),
                            ),
                          ],
                        ),
                        GoogleSignUpButton(context, Ionicons.logo_google, true, () { Login.googleLogin().then((value){
                          Navigator.pushReplacementNamed(context, '/home');});
                        }),
                        haveAccountOption()
                      ],
                    ),
                  )
                ],
              ),
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
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: const Text('Login Instead',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        )
      ],
    );

  }

}
