///This will check the platform on which the app is running.

import 'dart:io';

import 'package:flutter/foundation.dart';

enum PlatformType{
  android,
  ios,
  web,
  unknown
}

PlatformType determinePlatform() {
  if (Platform.isAndroid) {
    return PlatformType.android;
  } else if (Platform.isIOS) {
    return PlatformType.ios;
  } else if (kIsWeb) {
    return PlatformType.web;
  } else {
    return PlatformType.unknown;
  }
}

PlatformType currentPlatform = determinePlatform();

String device = '';

platform(){
  switch (currentPlatform) {
    case PlatformType.android:
      return device = 'Android';
    case PlatformType.ios:
      return device = 'ios';
    case PlatformType.web:
      return device = 'web';
    case PlatformType.unknown:
      return device = 'unknown';
  }
}

