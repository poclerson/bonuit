import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/home/home.dart';
import '../pages/schedules/schedules.dart';
import '../pages/settings/settings.dart';
import '../pages/stats/stats.dart';
import 'sort_method.dart';
import 'package:flutter/cupertino.dart';

class Screen {
  late String title;
  late IconData iconData;
  late GetPage getPage;

  Screen(this.title, this.iconData, this.getPage);
  Screen.home(this.getPage);

  static String pathToTitle(String path) {
    return screens.firstWhere((screen) => screen.getPage.name == path).title;
  }

  static List<Screen> screens = [
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
}
