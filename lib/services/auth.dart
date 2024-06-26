

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../viewable/home.dart';
import '../viewable/login.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return const MyHome();
            }else{
              return const LoginScreen();
            }
          },
      );
  }
}
