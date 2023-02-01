import 'package:flutter/material.dart';

List<Color> colors = [
  Color(0xFFFFCA1B),
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.purple,
  Colors.blue,
  Colors.red,
  Colors.green
];

class ColorPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Wrap(
            alignment: WrapAlignment.start,
            children: colors
                .map((color) => Container(
                      margin: EdgeInsets.all(15),
                      width: 50,
                      height: 50,
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: color),
                    ))
                .toList()),
      ],
    ));
  }
}
