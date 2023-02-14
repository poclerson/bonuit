import 'theme_picker.dart';
import 'package:flutter/material.dart';

class ThemeModePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ThemePicker(themeMode: ThemeMode.dark),
          ThemePicker(themeMode: ThemeMode.light),
          ThemePicker(themeMode: ThemeMode.system)
        ],
      ),
    );
  }
}
