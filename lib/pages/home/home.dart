import 'package:flutter/material.dart';
import '../../models/json.dart';
import 'hours_display.dart';
import '../../widgets/full_width_button.dart';
import '../stats/stats.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: HoursDisplay('10h23'),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FullWidthButton(Stats(), 'Statistiques', Icons.abc,
                        MaterialStatePropertyAll<Color>(Colors.green)),
                    FullWidthButton(Stats(), "Modifier l'horaire", Icons.abc,
                        MaterialStatePropertyAll<Color>(Colors.red)),
                    FullWidthButton(Stats(), 'Préférences', Icons.abc,
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
