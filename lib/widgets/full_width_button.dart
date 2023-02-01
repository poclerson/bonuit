import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {
  final String _text;
  final IconData _icon;
  final MaterialStatePropertyAll<Color> _color;
  final VoidCallback _onButtonPress;
  FullWidthButton(this._text, this._icon, this._color, this._onButtonPress);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: _onButtonPress,
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
