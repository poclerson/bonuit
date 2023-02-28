import 'package:bonuit/models/sleep_target.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'models/notification_controller.dart';
import 'models/app_theme.dart';
import 'models/app_theme.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationController.initialize();
  await AppTheme.initialize();
  await SleepTarget.initialize();
  NotificationController.printAllPendingNotificationRequests();
  runApp(App());
}
