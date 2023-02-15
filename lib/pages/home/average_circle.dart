import 'package:flutter/material.dart';
import '../../models/time_of_day_extension.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import '../../models/day.dart';

class AverageCircle extends StatefulWidget {
  Day averageDay;
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
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll<Color>(Colors.transparent),
            overlayColor: MaterialStatePropertyAll<Color>(Colors.transparent)),
        onPressed: () => widget.onPressed(),
        child: Column(children: [
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
                width: 300,
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
              Container(
                width: 350,
                height: 100,
                color: Colors.transparent,
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              widget.text,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          )
        ]),
      ),
    );
  }
}
