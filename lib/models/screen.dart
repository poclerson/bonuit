import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/screens.dart';

class Screen {
  late String title;
  late IconData iconData;
  late GetPage getPage;

  Screen(this.title, this.iconData, this.getPage);
  Screen.home(this.getPage);

  static String pathToTitle(String path) {
    return screens.firstWhere((screen) => screen.getPage.name == path).title;
  }
}
