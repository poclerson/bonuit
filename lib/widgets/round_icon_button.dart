import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  Color? color;
  Color? backgroundColor;
  final IconData icon;
  final Function onPressed;
  RoundIconButton({required this.icon, required this.onPressed});
  RoundIconButton.withColors(
      {required this.color,
      required this.backgroundColor,
      required this.icon,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    color ??= Theme.of(context).colorScheme.onPrimary;
    backgroundColor ??= Theme.of(context).colorScheme.primary;
    return Container(
      decoration:
          ShapeDecoration(shape: CircleBorder(), color: backgroundColor),
      child: IconButton(
        icon: Icon(
          icon,
          color: color,
        ),
        onPressed: () => onPressed(),
      ),
    );
  }
}
