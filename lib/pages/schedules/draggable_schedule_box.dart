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
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.schedule.color,
        ),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              widget.schedule.name[0].toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Theme.of(context).colorScheme.background),
            )),
      ),
      child: GestureDetector(
          onTap: () => widget.onEdited(),
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: widget.schedule.color,
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.schedule.name!,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                              color: Theme.of(context).colorScheme.background),
                    ),
                    Text(
                      widget.schedule.sleepTime.toStringFormatted(),
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.background),
                    ),
                    Text(
                      widget.schedule.wakeTime.toStringFormatted(),
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.background),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
