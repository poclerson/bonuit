import 'package:flutter/material.dart';
import '../../models/time_of_day_extension.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import '../../models/day.dart';

class AverageCircle extends StatefulWidget {
  SleepDay averageDay;
  double averageHoursSlept;
  String text;
  Function onPressed = () {};
  AverageCircle(
      {required this.averageDay,
      required this.averageHoursSlept,
      required this.text,
      required this.onPressed});

  @override
  _AverageCircleState createState() => _AverageCircleState();
}

class _AverageCircleState extends State<AverageCircle> {
  @override
  Widget build(BuildContext context) {
    PickedTime start = widget.averageDay.sleepTime.toPickedTime();
    PickedTime end = widget.averageDay.wakeTime.toPickedTime();
    return Flexible(
      child: GestureDetector(
        onTap: () => widget.onPressed(),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Stack(
            children: [
              TimePicker(
                initTime: start,
                endTime: end,
                onSelectionChange: (sleep, wake, isDisableRange) {
                  setState(() {});
                },
                onSelectionEnd: (sleep, wake, isDisableRange) {
                  setState(() {});
                },
                width: 150,
                height: 150,
                isInitHandlerSelectable: false,
                isEndHandlerSelectable: false,
                decoration: TimePickerDecoration(
                    baseColor: Theme.of(context).colorScheme.surface,
                    // Sélecteur
                    sweepDecoration: TimePickerSweepDecoration(
                      pickerStrokeWidth: 20,
                      pickerColor: start.isEqual(end)
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context).colorScheme.primary,
                      useRoundedPickerCap: true,
                    ),
                    // Poignée de début
                    initHandlerDecoration: TimePickerHandlerDecoration(
                      color: Colors.transparent,
                    ),
                    // Poignée de fin
                    endHandlerDecoration: TimePickerHandlerDecoration(
                      color: Colors.transparent,
                    ),
                    // Chiffres de l'horloge
                    clockNumberDecoration: TimePickerClockNumberDecoration(
                      defaultTextColor: Colors.transparent,
                    )),
                child: Align(
                  child: Text(
                    widget.averageHoursSlept.toTimeOfDay().toStringFormatted(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              // Container(
              //   width: 350,
              //   height: 100,
              //   color: Colors.transparent,
              // )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              widget.text,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          )
        ]),
      ),
    );
  }
}
