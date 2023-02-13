import 'package:flutter/material.dart';
import '../../models/schedule.dart';
import '../../widgets/round_icon_button.dart';
import '../../models/time_of_day_extension.dart';

class DraggableScheduleBox extends StatefulWidget {
  final Schedule schedule;
  final Function onDeleted;
  final Function onEdited;
  DraggableScheduleBox(
      {required this.schedule,
      required this.onDeleted,
      required this.onEdited});
  @override
  _DraggableScheduleBoxState createState() => _DraggableScheduleBoxState();
}

class _DraggableScheduleBoxState extends State<DraggableScheduleBox> {
  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Schedule>(
        data: widget.schedule,
        feedback: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.schedule.color,
          ),
          child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.schedule.name![0].toUpperCase(),
                style: TextStyle(
                    color: Colors.black, decoration: TextDecoration.none),
              )),
        ),
        child: Container(
          color: widget.schedule.color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RoundIconButton.withColors(
                  color: Theme.of(context).colorScheme.onBackground,
                  backgroundColor: Theme.of(context).colorScheme.error,
                  icon: Icons.delete,
                  onPressed: widget.onDeleted),
              Column(
                children: [
                  Text(
                    widget.schedule.name!,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(widget.schedule.sleepTime.toStringFormatted()),
                  Text(widget.schedule.wakeTime.toStringFormatted())
                ],
              ),
              RoundIconButton.withColors(
                color: widget.schedule.color,
                backgroundColor: Theme.of(context).colorScheme.background,
                icon: Icons.edit,
                onPressed: widget.onEdited,
              )
            ],
          ),
        ));
  }
}
