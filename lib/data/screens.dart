import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/home/home.dart';
import '../pages/stats/stats.dart';
import '../pages/settings/settings.dart';
import '../pages/schedules/schedules.dart';
import '../models/screen.dart';

List<Screen> screens = [
  Screen.home(GetPage(
    name: '/',
    page: () => Home(),
  )),
  Screen(
    'Préférences',
    Icons.settings,
    GetPage(
      name: '/settings',
      page: () => Settings(),
    ),
  ),
  Screen(
    'Statistiques',
    Icons.bar_chart_rounded,
    GetPage(
      name: '/stats',
      page: () => Stats(),
    ),
  ),
  Screen(
    "Modifier l'horaire",
    Icons.calendar_month_rounded,
    GetPage(
      name: '/schedule',
      page: () => Schedules(),
    ),
  ),
];
