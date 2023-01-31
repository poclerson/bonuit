import 'package:flutter/material.dart';
import '../../models/schedule.dart';

class DraggableScheduleBox extends StatefulWidget {
  final Schedule _schedule;
  DraggableScheduleBox(this._schedule);
  @override
  _DraggableScheduleBoxState createState() =>
      _DraggableScheduleBoxState(_schedule);
}

class _DraggableScheduleBoxState extends State<DraggableScheduleBox> {
  Schedule _schedule;
  _DraggableScheduleBoxState(this._schedule);
  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Schedule>(
        data: _schedule,
        feedback: Text(_schedule.name[0].toUpperCase()),
        child: Container(
            decoration: BoxDecoration(color: _schedule.color),
            child: Text(_schedule.name)));
  }
}
