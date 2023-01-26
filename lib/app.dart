import 'package:flutter/material.dart';

import 'package:sommeil/styles.dart';

import 'pages/home/home.dart';
import 'data/screens.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateRoute: _routes(), home: Home(), theme: appThemeData
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
}
