import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:auto_customer_care_app/services/net_check.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  checkNet() async {
    NetCheck.hasConnection = await NetCheck.checkConnection();
    if (NetCheck.hasConnection = true) {
      setState(() {
        NetCheck.showMessage = 'Connected';
      });
    } else if(NetCheck.hasConnection = false) {
      setState(() {
        NetCheck.showMessage = 'No Internet';
      });
    }
  }

  afterLoad(){
    Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/home');
      });
  }

  displayWhat(){
    if(NetCheck.showMessage == 'Connected'){
      afterLoad();
    }else if(NetCheck.showMessage == 'No Internet'){
      return Row(
        children: [
          IconButton(onPressed: (){
            checkNet();
          }, icon: const Icon(Icons.refresh))
        ],
      );
    }
    
  }
  
  @override
  void initState(){
    super.initState();
    checkNet();
    displayWhat();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.assistant, size: 55.0, color: Colors.white,),
                  SizedBox(width: 5.0,),
                  Text('Name', style: TextStyle(fontSize: 30.0, color: Colors.white))
                ],
              ),
              const SizedBox(height: 20.0,),
              const SpinKitDualRing(color: Colors.white70, size: 30.0,),
              const SizedBox(height: 20.0,),
              Text(NetCheck.showMessage, style: const TextStyle(fontSize: 15.0, color: Colors.white),),
              Padding(padding: EdgeInsets.zero,
              child: displayWhat(),)
            ],
          )),
    );
  }
}
