import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_theme.dart';

import 'data/screens.dart';
import 'pages/home/home.dart';
import 'models/simple_stream.dart';

class App extends StatelessWidget {
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

// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ModelTheme(),
//       child: Consumer<ModelTheme>(
//           builder: (context, ModelTheme themeNotifier, child) {
//         return GetMaterialApp(
//           initialRoute: '/',
//           home: Home(),
//           getPages: screens.map((screen) => screen.getPage).toList(),
//           theme: AppTheme.light,
//           darkTheme: AppTheme.dark,
//           themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
//         );
//       }),
//     );
//   }
// }
