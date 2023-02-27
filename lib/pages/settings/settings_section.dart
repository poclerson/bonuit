import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 75),
              child: AutoSizeText(title,
                  style: Theme.of(context).textTheme.titleLarge, maxLines: 1),
            ),
          ],
        ),
        SizedBox(
          height: 5,
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
