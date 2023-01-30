import 'package:flutter/material.dart';

class DraggableScheduleBox extends StatefulWidget {
  final String _text;
  final Color _color;
  DraggableScheduleBox(this._text, this._color);
  @override
  _DraggableScheduleBoxState createState() =>
      _DraggableScheduleBoxState(_text, _color);
}

class _DraggableScheduleBoxState extends State<DraggableScheduleBox> {
  String _text;
  Color _color;
  _DraggableScheduleBoxState(this._text, this._color);
  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
        child: Text(_text), feedback: Text(_text[0].toUpperCase()));
  }
}
