import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'app.dart';
import 'models/notification_controller.dart';
import 'models/background_controller.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationController.initialize();
  // BackgroundController.initialize();
  NotificationController.printAllPendingNotificationRequests();
  runApp(App());
}
