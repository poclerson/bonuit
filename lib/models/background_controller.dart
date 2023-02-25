import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import 'notification_controller.dart';

class BackgroundController {
  // static final FlutterBackgroundService service = FlutterBackgroundService();
  // static initialize() async {
  //   // Service
  //   // service.configure(
  //   //     iosConfiguration: IosConfiguration(
  //   //         autoStart: true,
  //   //         onForeground: onStartService,
  //   //         onBackground: onBackground),
  //   //     androidConfiguration: AndroidConfiguration(
  //   //         onStart: onStartService, isForegroundMode: true));
  //   // service.startService();

  //   // Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  //   // await Workmanager().registerOneOffTask('0', 'com.company.bonuit.simpleTask',
  //   //     // frequency: Duration(seconds: 10),
  //   //     constraints: Constraints(
  //   //         networkType: NetworkType.connected, requiresCharging: true),
  //   //     inputData: {'task-identifier': 'task-identifier'});

  //   BackgroundFetch.registerHeadlessTask(headlessTask);
  //   initPlatformState();
  //   BackgroundFetch.start()
  //       .then((value) => debugPrint('BackgroundFetch started successfully'))
  //       .catchError((e) => debugPrint('BackgroundFetch error $e'));
  // }

  // @pragma('vm:entry-point')
  // static callbackDispatcher() async {
  //   debugPrint('allo');
  //   Workmanager().executeTask((taskName, inputData) async {
  //     debugPrint('task');
  //     return Future.value(true);
  //   });
  //   debugPrint('workmanager');
  // }

  // static headlessTask(HeadlessTask task) async {
  //   String taskId = task.taskId;
  //   bool isTimeout = task.timeout;
  //   print('Headless task $taskId received');
  //   await NotificationController.show(NotificationController.sleepOptions);
  //   NotificationController.show(NotificationController.sleepOptions);
  //   BackgroundFetch.finish(taskId);
  // }

  // static initPlatformState() async {
  //   await BackgroundFetch.configure(
  //       BackgroundFetchConfig(
  //           startOnBoot: true,
  //           minimumFetchInterval: 15,
  //           stopOnTerminate: false,
  //           enableHeadless: true,
  //           requiresBatteryNotLow: true,
  //           requiresCharging: true,
  //           requiresDeviceIdle: false,
  //           requiredNetworkType: NetworkType.ANY), (String taskId) async {
  //     debugPrint('Yolo');
  //     await NotificationController.show(NotificationController.wakeOptions);
  //     BackgroundFetch.finish(taskId);
  //   }).then((value) => debugPrint('$value init'));
  // }

  // @pragma('vm:entry-point')
  // static onStartService(ServiceInstance service) {
  //   DartPluginRegistrant.ensureInitialized();

  //   if (service is AndroidServiceInstance) {
  //     service.on('setAsForeground').listen((event) {
  //       service.invoke('setAsForeground');
  //       service.setAsForegroundService();
  //     });

  //     service.on('setAsBackground').listen((event) {
  //       service.setAsBackgroundService();
  //     });
  //   }

  //   service.on('stopService').listen((event) {
  //     service.stopSelf();
  //   });
  // }

  // @pragma('vm:entry-point')
  // static onForeground(ServiceInstance service) {}
  // @pragma('vm:entry-point')
  // static Future<bool> onBackground(ServiceInstance service) async {
  //   debugPrint('onbackground');
  //   WidgetsFlutterBinding.ensureInitialized();
  //   DartPluginRegistrant.ensureInitialized();

  //   return true;
  // }
}
