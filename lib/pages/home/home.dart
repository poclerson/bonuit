import 'package:flutter/material.dart';

import '../../data/screens.dart';
import '../../models/screen.dart';

import 'hours_display.dart';
import 'average_circle.dart';
import '../../widgets/full_width_button.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Column(
                    children: [HoursDisplay('10h23'), Text('nuit dernière')],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [AverageCircle(), AverageCircle()],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...screens
                        .where((screen) =>
                            screen.getPage.name != '/') // Enlever Home
                        .map((screen) => FullWidthButton(screen.getPage.name,
                            screen.iconData, screen.color)),
                  ],
                ),
              ],
            )));
  }
}
