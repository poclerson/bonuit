import 'package:flutter/material.dart';
import 'package:sommeil/styles.dart';
import 'nav_bar.dart';
import 'pages/home/home.dart';
import 'pages/stats/stats.dart';
import 'models/screen.dart';

List<Screen> screens = [
  Screen('/', 'Home', Home()),
  Screen('/stats', 'Stats', Stats())
];

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(onGenerateRoute: _routes(), home: Home(), theme: _theme()
        // builder: (context, child) {
        //   return Overlay(
        //     initialEntries: [
        //       OverlayEntry(
        //           builder: (context) => Scaffold(
        //                 bottomNavigationBar: NavBar(),
        //               ))
        //     ],
        //   );
        // },
        );
  }

  RouteFactory _routes() {
    return (settings) {
      Widget screen =
          screens.where((screen) => screen.name == settings.name).first.widget;

      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }

  ThemeData _theme() {
    return ThemeData(
        appBarTheme: AppBarTheme(toolbarTextStyle: AppBarTextStyle),
        textTheme: TextTheme(
            titleMedium: TitleTextStyle,
            bodyMedium: BodyTextStyle,
            displayMedium: DisplayTextStyle));
  }
}
