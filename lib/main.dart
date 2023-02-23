import 'package:flutter/material.dart';
import 'app.dart';
import 'models/notification_controller.dart';
import 'models/background_controller.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationController.initialize();
  BackgroundController.initialize();
  runApp(App());
}
