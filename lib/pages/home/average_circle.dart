import 'package:flutter/material.dart';
import '../../models/day.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';

class AverageCircle extends StatefulWidget {
  double _averageHoursSlept;
  String _text;
  Function _onPressed = () {};
  AverageCircle(this._averageHoursSlept, this._text, this._onPressed);

  late Map<String, double> dataMap = {
    'fill': _averageHoursSlept,
    'rest': 24 - _averageHoursSlept
  };
  @override
  _AverageCircleState createState() => _AverageCircleState();
}

class _AverageCircleState extends State<AverageCircle> {
  @override
  Widget build(BuildContext context) {
    PickedTime start = PickedTime(h: 0, m: 0);
    PickedTime end = PickedTime(
        h: widget._averageHoursSlept.toTimeOfDay().hour,
        m: widget._averageHoursSlept.toTimeOfDay().minute);
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll<Color>(Colors.transparent),
            overlayColor: MaterialStatePropertyAll<Color>(Colors.transparent)),
        onPressed: () => widget._onPressed(),
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
                    baseColor: Theme.of(context).colorScheme.background,
                    // Sélecteur
                    sweepDecoration: TimePickerSweepDecoration(
                      pickerStrokeWidth: 20,
                      pickerColor: Theme.of(context).colorScheme.primary,
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
                    widget._averageHoursSlept.toTime(),
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
              widget._text,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          )
        ]),
      ),
    );
  }
}
