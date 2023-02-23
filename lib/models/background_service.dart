import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

class BackgroundService {
  static final FlutterBackgroundService backgroundService =
      FlutterBackgroundService();
  static initialize() async {
    backgroundService.configure(
        iosConfiguration: IosConfiguration(
            autoStart: true, onForeground: onStart, onBackground: onBackground),
        androidConfiguration:
            AndroidConfiguration(onStart: onStart, isForegroundMode: true));
    backgroundService.startService();
  }

  @pragma('vm:entry-point')
  static onStart(ServiceInstance service) {
    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.invoke('setAsForeground');
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  @pragma('vm:entry-point')
  static onForeground(ServiceInstance service) {}
  @pragma('vm:entry-point')
  static Future<bool> onBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
            title: 'App in background...', content: 'Allo');
      }

      if (service is IOSServiceInstance) {
        // service.setForegroundNotificationInfo();
      }
    });
    return true;
  }
}
