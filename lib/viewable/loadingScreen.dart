import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:auto_customer_care_app/services/net_check.dart';

class Loading extends StatefulWidget {
  Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  String showMessage = 'Checking Connection';
  late bool hasConnection;

  void checkNet() async {
    hasConnection = await NetCheck.checkConnection();
    if (hasConnection = true) {
      setState(() {
        showMessage = 'Connected';
      });
    } else {
      setState(() {
        showMessage = 'No Internet';
      });
    }
  }
  
  displayWhat() async {
    if(showMessage == 'Connected'){

    }else if(showMessage == 'No Internet'){
      return Row();
    }
    
  }
  
  @override
  void initState(){
    super.initState();
    checkNet();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: const [
              Icon(Icons.assistant),
              Text(''),
              SpinKitDualRing(color: Colors.blue, size: 30.0,)
            ],
          )),
    );
  }
}
