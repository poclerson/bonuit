import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  Icon icon;
  String text;
  Widget action;
  Function onPressed;
  SettingsButton(
      {required this.icon,
      required this.text,
      required this.action,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => onPressed(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(text),
            SizedBox(
              width: 20,
            ),
            Expanded(child: SizedBox()),
            action
          ],
        ));
  }
}
