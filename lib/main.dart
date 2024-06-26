// @dart=2.9
import 'package:auto_customer_care/services/auth.dart';
import 'package:auto_customer_care/viewable/AddProfilePic.dart';
import 'package:auto_customer_care/viewable/ambulance.dart';
import 'package:auto_customer_care/viewable/appointment.dart';
import 'package:auto_customer_care/viewable/chatDoctor.dart';
import '../viewable/chatpage.dart';
import '../viewable/home.dart';
import '../viewable/login.dart';
import '../viewable/signup.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'viewable/userProfile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(MaterialApp(
    themeMode: ThemeMode.system,
    home: const Auth(),
    routes: {
      '/home': (context) => const MyHome(),
      '/sign': (context) => const SignUp(),
      '/login': (context) => const LoginScreen(),
      '/chat': (context) => const BotChat(),
      '/doc': (context) => const DocChat(),
      '/auth': (context) => const Auth(),
      '/ambie': (context) => const AmbulanceRequestPage(),
      '/appoint': (context) => const AppointmentForm(),
      '/userProfile': (context) => const UserProfile(),
      '/addProfilePic': (context) => const AddProfilePic()
    },
  ));
}