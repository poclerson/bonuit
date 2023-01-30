import 'package:flutter/material.dart';
import '../../models/schedule.dart';

class Weekday extends StatefulWidget {
  final String _day;
  final Color _color;
  Weekday(this._day, this._color);
  @override
  _WeekdayState createState() => _WeekdayState(_day, _color);
}

class _WeekdayState extends State<Weekday> {
  String _day;
  Color _color;
  _WeekdayState(this._day, this._color);
  @override
  Widget build(BuildContext context) {
    return DragTarget<Weekday>(
      builder: (context, candidateData, rejectedData) {
        return Container(
            padding: EdgeInsets.all(30),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Text(_day[0].toUpperCase()));
      },
      onAccept: (weekday) {
        _onScheduleDroppedOnWeekday(name: 'Allo', color: Colors.red);
      },
    );
  }

  void _onScheduleDroppedOnWeekday(
      {required String name, required Color color}) {
    setState(() {});
  }
}
