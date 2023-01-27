import 'package:flutter/material.dart';
import '../styles.dart';
import 'package:get/get.dart';

class FullWidthButton extends StatelessWidget {
  final String _text;
  final IconData? _icon;
  final MaterialStatePropertyAll<Color> _color;
  FullWidthButton(this._text, this._icon, this._color);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Get.toNamed(_text);
      },
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
