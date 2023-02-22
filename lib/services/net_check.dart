///The basic function of this class is to just check if the device has a working internet connection.
///mainly for the android and ios platforms.

import 'dart:io';
import 'platformCheck.dart';

class NetCheck {
  static String device = '';
  platform() {
    switch (currentPlatform) {
      case PlatformType.android:
        device = 'Android';
        break;
      case PlatformType.ios:
        device = 'ios';
        break;
      case PlatformType.web:
        device = 'web';
        break;
      case PlatformType.unknown:
        device = 'unknown';
    }
  }
}
