import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../addons/buttons&fields.dart';
import '../addons/drawer.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: MainSideBar(),
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text(
          'SpecanCare Support ',
          style: TextStyle(fontSize: 23.0, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(w * 0.01, h * 0.03, w * 0.01, h * 0.1),
        child: Column(
          children: [
            Text('Welcome ${FirebaseAuth.instance.currentUser?.displayName}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                newChatButton(context, Ionicons.person, false, (){}),
                const SizedBox(width: 10.0,),
                newChatButton(context, Icons.live_help_rounded, true, () {})
              ],
            ),
            TextButton(onPressed: (){FirebaseAuth.instance.signOut().then((value) => Navigator.pushReplacementNamed(context, '/login'));},
                child: const Text('Log-Out'))
          ],
        ),
      ),
    );
  }
}
