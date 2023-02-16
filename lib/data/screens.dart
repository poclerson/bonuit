import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/home/home.dart';
import '../pages/stats/stats.dart';
import '../pages/settings/settings.dart';
import '../pages/schedules/schedules.dart';
import '../models/screen.dart';
import '../models/sort_method.dart';
import 'package:flutter/cupertino.dart';

List<Screen> screens = [
  Screen.home(GetPage(
    name: '/',
    page: () => Home(),
  )),
  Screen(
    'Préférences',
    CupertinoIcons.gear_alt_fill,
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
      page: () => Stats(SortMethod.weekly),
    ),
  ),
  Screen(
    "Modifier l'horaire",
    CupertinoIcons.calendar,
    GetPage(
      name: '/schedule',
      page: () => Schedules(),
    ),
  ),
];
