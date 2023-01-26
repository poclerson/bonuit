import 'package:flutter/material.dart';

import '../pages/home/home.dart';
import '../pages/stats/stats.dart';
import '../pages/settings/settings.dart';
import '../pages/schedule/schedule.dart';
import '../models/screen.dart';

List<Screen> screens = [
  Screen.route('/', 'Home', Home()),
  Screen('/stats', 'Stats', Stats(), Icons.vertical_align_bottom_rounded,
      MaterialStatePropertyAll<Color>(Colors.orange)),
  Screen(
      '/schedule',
      "Modifier l'horaire",
      Schedule(),
      Icons.calendar_month_outlined,
      MaterialStatePropertyAll<Color>(Colors.green)),
  Screen('/settings', 'Préférences', Stats(), Icons.settings,
      MaterialStatePropertyAll<Color>(Colors.red)),
];
