import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String showMessage = 'Loading...';
  String device = 'web';

  checkConnection() async {

    setState(() {
      showMessage = 'Loading...';
    });

    if (kIsWeb) {
      afterLoad();
    } else if (Platform.isAndroid || Platform.isIOS) {
      setState(() {
        showMessage = 'Loading...';
      });

      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            showMessage = 'Almost Done!';
          });
        }
      } on SocketException catch (_) {
        setState(() {
          showMessage = 'Error! No Internet';
        });
      }
    }
  }

  afterLoad() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  displayWhat() {
    if (showMessage == 'Almost Done!') {
      afterLoad();
    } else if (showMessage == 'Error! No Internet') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                checkConnection();
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 30.0,
              ),
              label: const Text(
                'Reload',
                style: TextStyle(fontSize: 17.0),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.white60;
                }
                return Colors.black;
              })),
            ),
          ),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                SystemNavigator.pop();
              },
              icon: const Icon(
                Icons.exit_to_app_sharp,
                color: Colors.white,
                size: 30.0,
              ),
              label: const Text(
                'Exit',
                style: TextStyle(fontSize: 17.0),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.white60;
                }
                return Colors.black;
              })),
            ),
          )
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    displayWhat();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: h * 0.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.assistant,
                  size: 55.0,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text('IzoCare',
                    style: TextStyle(fontSize: 30.0, color: Colors.white))
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const SpinKitDualRing(
            color: Colors.white70,
            size: 30.0,
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            showMessage,
            style: const TextStyle(fontSize: 15.0, color: Colors.white),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(w * 0.08, h * 0.4, w * 0.08, h * 0.01),
            child: displayWhat(),
          )
        ],
      )),
    );
  }
}
