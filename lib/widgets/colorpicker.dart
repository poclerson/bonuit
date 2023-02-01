import 'package:flutter/material.dart';

List<Color> colors = [
  Color(0xFFFFCA1B),
  Color(0xFFFF501B),
  Color(0xFF4DD3AB),
  Color(0xFF581BFF),
  Color(0xFFD4D4D4),
  Color(0xFF6E6E6E),
  Color(0xFF249236),
  Color(0xFFCA23E0),
];

class ColorPicker extends StatelessWidget {
  final Function(Color color) _onColorPressed;
  ColorPicker(this._onColorPressed);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Wrap(
            alignment: WrapAlignment.start,
            children: colors
                .map((color) => TextButton(
                    onPressed: () => _onColorPressed(color),
                    style: Theme.of(context).textButtonTheme.style!.copyWith(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Colors.transparent)),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      width: 50,
                      height: 50,
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: color),
                    )))
                .toList()),
      ],
    ));
  }
}
