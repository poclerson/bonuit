import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/home/home.dart';
import '../pages/stats/stats.dart';
import '../pages/settings/settings.dart';
import '../pages/schedule/schedule.dart';
import '../models/screen.dart';

List<Screen> screens = [
  Screen.home(GetPage(
    name: '/',
    page: () => Home(),
  )),
  Screen(
    Icons.settings,
    MaterialStatePropertyAll<Color>(Colors.red),
    GetPage(
      name: '/settings',
      page: () => Settings(),
    ),
    // 'Préférences',
  ),
  Screen(
    Icons.vertical_align_bottom_rounded,
    MaterialStatePropertyAll<Color>(Colors.green),
    GetPage(
      name: '/stats',
      page: () => Stats(),
    ),
    // 'Statistiques',
  ),
  Screen(
    Icons.calendar_month_rounded,
    MaterialStatePropertyAll<Color>(Colors.orange),
    GetPage(
      name: '/schedule',
      page: () => Schedule(),
    ),
    // "Modifier l'horaire",
  ),
];
