import 'package:flutter/material.dart';
import '../styles.dart';

class FullWidthButton extends StatelessWidget {
  Widget _widget;
  String _text;
  IconData? _icon;
  MaterialStatePropertyAll<Color> _color;

  FullWidthButton(this._widget, this._text, this._icon, this._color);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => _widget));
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(_text),
        Icon(
          _icon,
          size: 40,
        )
      ]),
      style: ButtonTextStyle.copyWith(backgroundColor: _color),
    );
  }
}
