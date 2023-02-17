import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  String text;
  Widget content;
  Function onPressed;
  SettingsButton(
      {required this.text, required this.content, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 15,
      children: [
        TextButton(
            onPressed: () => onPressed(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                content
              ],
            ))
      ],
    );
  }
}
