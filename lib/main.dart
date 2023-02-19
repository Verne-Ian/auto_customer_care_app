import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
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

          ],
        ),
      ),
    );
  }
}

