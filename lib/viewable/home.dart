import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';

import '../addons/buttons&fields.dart';
import '../addons/drawer.dart';
import '../services/MainServices.dart';

class MyHome extends StatefulWidget {
   const MyHome({Key? key}) : super(key: key);


  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;
    // ignore: unused_local_variable
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: w * 1.0),
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: const MainSideBar(),
          appBar: AppBar(
            backgroundColor: Colors.black54,
            title: const Text(
              'SpecanCare Support ',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(w * 0.02, h * 0.03, w * 0.02, h * 0.1),
              child: Column(
                children: [
                  FutureBuilder<User>(
                    future: Future.value(currentUser), // Wrap the currentUser in a Future
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final userName = snapshot.data!.displayName; // Access the name property
                        return Text('Hello there, $userName!');
                      } else {
                        return const SpinKitDualRing(
                          color: Colors.green,
                          size: 15.0,
                        );
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: newChatButton(
                            context, Icons.live_help_rounded, true, () {
                          Navigator.pushNamed(context, '/chat');
                        }, 'Quick Help'),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                          flex: 1,
                          child:
                          newChatButton(context, Ionicons.car, false, () {
                            Navigator.pushNamed(context, '/ambie');
                          }, 'Request Ambulance')),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: newChatButton(
                            context, Ionicons.book_outline, true, () {
                          Navigator.pushNamed(context, '/appoint');
                        }, 'Make Appointment'),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                          flex: 1,
                          child: newChatButton(context, Ionicons.person, false, () {
                            Navigator.pushNamed(context, '/doc');
                          }, 'Doctor')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child:
                          newChatButton(context, Ionicons.car, false, () {
                            Navigator.pushNamed(context, '/ambie');
                          }, 'Dentist')),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: 1,
                        child: newChatButton(
                            context, Ionicons.book_outline, true, () {
                          Navigator.pushNamed(context, '/appoint');
                        }, 'Physician'),
                      )
                    ],
                  ),
                  /*TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: const Text('Log-Out'))

                   */
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
