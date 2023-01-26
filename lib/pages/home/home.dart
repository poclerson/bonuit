import 'package:flutter/material.dart';

import 'hours_display.dart';
import 'average_circle.dart';
import '../../widgets/full_width_button.dart';

import '../stats/stats.dart';
import '../schedule/schedule.dart';
import '../settings/settings.dart';

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
                    FullWidthButton(
                        Stats(),
                        'Statistiques',
                        Icons.align_vertical_bottom_rounded,
                        MaterialStatePropertyAll<Color>(Colors.green)),
                    FullWidthButton(
                        Schedule(),
                        "Modifier l'horaire",
                        Icons.calendar_today_outlined,
                        MaterialStatePropertyAll<Color>(Colors.red)),
                    FullWidthButton(Settings(), 'Préférences', Icons.settings,
                        MaterialStatePropertyAll<Color>(Colors.orange)),
                  ],
                ),
              ],
            )));
  }

  _navigate(BuildContext context, String path) {
    Navigator.pushNamed(context, path);
  }
}
