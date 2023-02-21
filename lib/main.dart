
import 'package:auto_customer_care_app/viewable/loadingScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/load',
    routes: {
      '/load': (context) => const Loading(),
      '/home': (context) => const MyApp()
    },
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Kelly\'s Support ',
        style: TextStyle(
            fontSize: 30.0,
            color: Colors.white),),
      centerTitle: true,),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, h*0.03, 0, h*0.1),
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

