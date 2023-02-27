import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'app.dart';
import 'models/notification_controller.dart';
import 'models/app_theme.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationController.initialize();
  await AppTheme.initialize();
  NotificationController.printAllPendingNotificationRequests();
  runApp(App());
}
