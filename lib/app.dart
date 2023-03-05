import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/app_theme.dart';

import 'models/screen.dart';
import 'pages/home/home.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeMode>(
        initialData: AppTheme.themeMode.current,
        stream: AppTheme.themeMode.output,
        builder: ((context, snapshot) {
          return GetMaterialApp(
            initialRoute: '/',
            debugShowCheckedModeBanner: false,
            home: Home(),
            getPages: Screen.screens.map((screen) => screen.getPage).toList(),
            theme: AppTheme.themeBuilder(LightColorScheme),
            darkTheme: AppTheme.themeBuilder(DarkColorScheme),
            themeMode: snapshot.data!,
          );
        }));
  }
}
