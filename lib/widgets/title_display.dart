import 'package:flutter/material.dart';
import '../styles.dart';

class TitleDisplay extends StatelessWidget {
  final String text;
  TextStyle? textStyle;
  TitleDisplay(this.text);
  TitleDisplay.styleWith(this.text, this.textStyle);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(30.0, 10.0, 10.0, 10.0),
        child: Text(
          text,
          style: (textStyle ?? DisplayTextStyle).copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2),
          textAlign: TextAlign.center,
        ));
  }
}
