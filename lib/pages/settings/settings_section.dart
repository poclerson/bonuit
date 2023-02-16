import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  IconData iconData;
  String title;
  List<Widget> children;
  bool isButtonSection;
  SettingsSection(
      {required this.iconData,
      required this.title,
      required this.children,
      this.isButtonSection = true});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              iconData,
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
            )
          ],
        ),
        Container(
          decoration: BoxDecoration(
              color: !isButtonSection
                  ? Theme.of(context).colorScheme.surface
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [...children],
          ),
        )
      ],
    );
  }
}
