import 'package:flutter/material.dart';

class HoursDisplay extends StatelessWidget {
  final String text;
  HoursDisplay(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(30.0, 10.0, 10.0, 10.0),
        child: Text(
          '10h23',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2),
          textAlign: TextAlign.center,
        ));
  }
}
