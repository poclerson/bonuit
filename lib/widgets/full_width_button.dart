import 'package:flutter/material.dart';
import '../styles.dart';

class FullWidthButton extends StatelessWidget {
  final String _text;
  final IconData _icon;
  final MaterialStatePropertyAll<Color> _color;
  final VoidCallback _onButtonPress;
  FullWidthButton(this._text, this._icon, this._color, this._onButtonPress);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _onButtonPress,
      style: ButtonTextStyle.copyWith(backgroundColor: _color),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(_text),
        Icon(
          _icon,
          size: 40,
        )
      ]),
    );
  }
}
