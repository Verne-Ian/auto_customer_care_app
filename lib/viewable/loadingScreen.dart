import 'dart:io';

import 'package:auto_customer_care/viewable/home.dart';
import 'package:auto_customer_care/viewable/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/auth.dart';


class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String showMessage = '';

  checkConnection() async {

    setState(() {
      showMessage = 'Loading...';
    });

    if (kIsWeb) {
      const Auth();
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

  displayWhat() {
    if (showMessage == 'Almost Done!') {
     return Auth();
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
                size: 25.0,
              ),
              label: const Text(
                'Reload',
                style: TextStyle(fontSize: 15.0),
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
                size: 25.0,
              ),
              label: const Text(
                'Exit',
                style: TextStyle(fontSize: 15.0),
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
    double textSize = w*0.025;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: w,
            height: h*0.6,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/SpecanCare.png"), fit: BoxFit.cover),),
          ),
          Padding(
            padding: EdgeInsets.only(top: h * 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('SpecanCare',
                    style: TextStyle(fontSize: w*0.08, color: Colors.white))
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
            height: 15.0,
          ),
          Text(
            showMessage,
            style: TextStyle(fontSize: textSize, color: Colors.white),
          ),
          const SizedBox(
            height: 15.0,
          ),
        ],
      )),
    );
  }
}
