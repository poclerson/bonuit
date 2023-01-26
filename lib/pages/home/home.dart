import 'package:flutter/material.dart';
import '../../nav_bar.dart';
import '../../models/hour.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 10.0, 10.0),
                  child: Text(
                    Hour.now(),
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )));
  }
}
