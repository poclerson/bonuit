import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_theme.dart';

import 'data/screens.dart';
import 'pages/home/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      home: Home(),
      getPages: screens.map((screen) => screen.getPage).toList(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
    );
  }
}
