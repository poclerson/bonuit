import 'package:flutter/material.dart';

List<Color> colors = [
  Color(0xFFFFCA1B),
  Color(0xFFE0613A),
  Color(0xFF60D3B0),
  Color(0xFF774EE7),
  Color(0xFF6E6E6E),
  Color(0xFF50C964),
  Color(0xFFC64AD6),
  Color(0xFF446BEE)
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
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.transparent),
                        overlayColor: MaterialStatePropertyAll<Color>(color)),
                    child: Container(
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
