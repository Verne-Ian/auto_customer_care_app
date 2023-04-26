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
          body: Padding(
            padding: EdgeInsets.fromLTRB(w * 0.02, h * 0.03, w * 0.02, h * 0.1),
            child: Column(
              children: [
                Text(
                    'Welcome ${FirebaseAuth.instance.currentUser?.displayName}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 1,
                        child:
                            newChatButton(context, Ionicons.person, false, () {
                          Navigator.pushNamed(context, '/human');
                        })),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: newChatButton(
                          context, Icons.live_help_rounded, true, () {
                        Navigator.pushNamed(context, '/chat');
                      }),
                    )
                  ],
                ),
                TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: const Text('Log-Out'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
