

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../viewable/home.dart';
import '../viewable/login.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return const MyHome();
            }else{
              return const LoginScreen();
            }
          },
        ),
      );
  }
}
