import 'package:auto_customer_care/services/auth.dart';

import '../viewable/chatpage.dart';
import '../viewable/home.dart';
import '../viewable/loadingScreen.dart';
import '../viewable/login.dart';
import '../viewable/signup.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(MaterialApp(
    home: const Auth(),
    //initialRoute: '/load',
    routes: {
      '/load': (context) => const Loading(),
      '/home': (context) => const MyHome(),
      '/sign': (context) => const SignUp(),
      '/login': (context) => const LoginScreen(),
      '/chat': (context) => const BotChat(),
      '/auth': (context) => const Auth()
    },
  ));
}
