import 'package:flutter/material.dart';

class NewScheduleSection extends StatelessWidget {
  final String? title;
  final List<Widget> content;
  NewScheduleSection({this.title, required this.content});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          if (title != null)
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ...content
        ],
      ),
    );
  }
}
