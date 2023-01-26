import 'package:flutter/material.dart';

class Screen {
  String route;
  String name;
  Widget widget;
  late IconData iconData;
  late MaterialStatePropertyAll<Color> color;

  Screen(this.route, this.name, this.widget, this.iconData, this.color);
  Screen.route(this.route, this.name, this.widget);
}
