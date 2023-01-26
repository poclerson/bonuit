import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Screen {
  late IconData iconData;
  late MaterialStatePropertyAll<Color> color;
  late GetPage getPage;

  Screen(this.iconData, this.color, this.getPage);
  Screen.home(this.getPage);
}
