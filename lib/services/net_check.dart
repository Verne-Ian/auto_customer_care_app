///The basic function of this class is to just check if the device has a working internet connection.
///mainly for the android and ios platforms.

import 'dart:io';

import 'platformCheck.dart';


class NetCheck{

  static String showMessage = 'Connecting';
  static bool hasConnection = false;

  static checkConnection() async {
    showMessage = 'Checking Connection';
    if(device == 'Android' || device == 'ios'){
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }else{
      return true;
    }
    }

}

