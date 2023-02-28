import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/app_theme.dart';

import 'models/screen.dart';
import 'pages/home/home.dart';
import 'package:background_fetch/background_fetch.dart';

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      // On réouvre l'application
      case AppLifecycleState.resumed:
        debugPrint('Resume');
        break;
      // On sort de l'application
      case AppLifecycleState.paused:
        debugPrint('Paused');
        break;
      // On ferme l'application
      case AppLifecycleState.detached:
        debugPrint('Detached');
        break;
      default:
    }
    super.didChangeAppLifecycleState(state);
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
