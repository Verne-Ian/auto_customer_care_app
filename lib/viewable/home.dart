import 'package:flutter/material.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black54,
        title: const Text(
          'SpecanCare Support ',
          style: TextStyle(fontSize: 23.0, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(w*0.01, h * 0.03, w*0.01, h * 0.1),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 0.0,
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: TextButton.icon(
                          onPressed: (){
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          icon: const Icon(Icons.add, color: Colors.white, size: 30.0,),
                          label: const Text('New Chat', style: TextStyle(color: Colors.white, fontSize: 25.0),)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}