import 'package:flutter/material.dart';
import '../../models/schedule.dart';
import '../../widgets/choices_prompt.dart';

class DraggableScheduleBox extends StatefulWidget {
  final Schedule _schedule;
  final Function _onDeleted;
  DraggableScheduleBox(this._schedule, this._onDeleted);
  @override
  _DraggableScheduleBoxState createState() =>
      _DraggableScheduleBoxState(_schedule);
}

class _DraggableScheduleBoxState extends State<DraggableScheduleBox> {
  Schedule _schedule;
  _DraggableScheduleBoxState(this._schedule);
  @override
  Widget build(BuildContext context) {
    bool _accepted;
    return LongPressDraggable<Schedule>(
        data: _schedule,
        feedback: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _schedule.color,
          ),
          child: Align(
              alignment: Alignment.center,
              child: Text(
                _schedule.name[0].toUpperCase(),
                style: TextStyle(
                    color: Colors.black, decoration: TextDecoration.none),
              )),
        ),
        child: TextButton(
            style: Theme.of(context).textButtonTheme.style!.copyWith(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(_schedule.color),
                foregroundColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).colorScheme.onPrimary),
                overlayColor: MaterialStatePropertyAll<Color>(
                    HSLColor.fromColor(_schedule.color)
                        .withLightness(.45)
                        .toColor())),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: ((context) =>
                      ChoicesPrompt(_schedule, widget._onDeleted)));
              setState(() {});
            },
            child: Align(
              alignment: Alignment.center,
              child: Text(_schedule.name),
            )));
  }
}
