import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_theme.dart';

import 'data/screens.dart';
import 'pages/home/home.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeMode>(
        initialData: ThemeMode.dark,
        stream: AppTheme.themeMode.output,
        builder: ((context, snapshot) {
          return GetMaterialApp(
            initialRoute: '/',
            debugShowCheckedModeBanner: false,
            home: Home(),
            getPages: screens.map((screen) => screen.getPage).toList(),
            theme: AppTheme.themeBuilder(LightColorScheme),
            darkTheme: AppTheme.themeBuilder(DarkColorScheme),
            themeMode: snapshot.data!,
          );
        }));
  }
}
