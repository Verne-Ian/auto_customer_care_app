import 'package:auto_customer_care_app/viewable/loadingScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/load',
    routes: {
      '/load': (context) => const Loading(),
      '/home': (context) => const MyHome()
    },
  ));
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'IzoCare Support ',
          style: TextStyle(fontSize: 30.0, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, h * 0.03, 0, h * 0.1),
        child: Column(
          children: const [
            Card(
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
