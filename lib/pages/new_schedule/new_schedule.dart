import 'package:flutter/material.dart';
import '../../widgets/nav_bar.dart';
import '../../widgets/colorpicker.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import '../../widgets/text_prompt.dart';
import '../../models/schedule.dart';
import 'dart:core';
import 'package:get/get.dart';

class NewSchedule extends StatefulWidget {
  String _appBarText;
  Future<List<Schedule>> _schedules;
  Function _updateSchedules;
  NewSchedule(this._appBarText, this._schedules, this._updateSchedules);
  @override
  _NewScheduleState createState() => _NewScheduleState();
}

class _NewScheduleState extends State<NewSchedule> {
  Color _appBarTextColor = Colors.white;
  final PickedTime _defaultSleepTime = PickedTime(h: 0, m: 0);
  final PickedTime _defaultWakeTime = PickedTime(h: 8, m: 0);
  late PickedTime _sleepTime;
  late PickedTime _wakeTime;
  late String _timeInterval =
      pickedTimeIntervalToString(_defaultSleepTime, _defaultWakeTime);
  @override
  Widget build(BuildContext context) {
    _sleepTime = _defaultSleepTime;
    _wakeTime = _defaultWakeTime;

    /// Ajouter le Prompt aux fonctions ouvertes onLoad
    WidgetsBinding.instance
        .addPostFrameCallback(widget._appBarText == 'Nouvel horaire'
            ? (_) => showDialog(
                context: context,
                builder: (context) => TextPrompt((value) {
                      setState(() {
                        widget._appBarText = value;
                      });
                    }))
            : (_) {});

    /// Widgets à être instantiés dans le ListView
    List<Widget> _listViewWidgets = [
      Text(
        'Couleur',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      ColorPicker((Color color) {
        setState(() {
          _appBarTextColor = color;
        });
      }),
      Text(
        'Temps de sommeil',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      TimePicker(
        initTime: _defaultSleepTime,
        endTime: _defaultWakeTime,
        onSelectionChange: (sleep, wake, isDisableRange) {
          setState(() {
            _timeInterval = pickedTimeIntervalToString(sleep, wake);
          });
        },
        onSelectionEnd: (sleep, wake, isDisableRange) {
          setState(() {
            _sleepTime = sleep;
            _wakeTime = wake;
          });
        },
        width: 400,
        height: 400,
        primarySectors: 12,
        secondarySectors: 48,
        decoration: TimePickerDecoration(
            baseColor: Theme.of(context).colorScheme.onBackground,
            // Grands diviseurs
            primarySectorsDecoration: TimePickerSectorDecoration(
                width: 2,
                radiusPadding: 30,
                color: Theme.of(context).colorScheme.onBackground,
                size: 5),
            // Petits diviseurs
            secondarySectorsDecoration: TimePickerSectorDecoration(
                width: 2,
                radiusPadding: 30,
                color: Theme.of(context).colorScheme.surface,
                size: 2.5),
            // Sélecteur
            sweepDecoration: TimePickerSweepDecoration(
              pickerStrokeWidth: 40,
              pickerColor: Theme.of(context).colorScheme.primary,
              useRoundedPickerCap: true,
            ),
            // Poignée de début
            initHandlerDecoration: TimePickerHandlerDecoration(
              color: Colors.transparent,
              icon: Icon(
                Icons.bed,
                size: 25,
              ),
            ),
            // Poignée de fin
            endHandlerDecoration: TimePickerHandlerDecoration(
                color: Colors.transparent,
                icon: Icon(
                  Icons.alarm,
                  size: 25,
                )),
            // Chiffres de l'horloge
            clockNumberDecoration: TimePickerClockNumberDecoration(
                clockTimeFormat: ClockTimeFormat.TWENTYFOURHOURS,
                defaultTextColor: Theme.of(context).colorScheme.primary,
                clockIncrementTimeFormat: ClockIncrementTimeFormat.FIFTEENMIN,
                scaleFactor: 2.75,
                textScaleFactor: .4)),
        child: Align(
          child: Text(
            _timeInterval,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ),
      OutlinedButton(
          onPressed: () {
            Schedule.pickedTime(
                    name: widget._appBarText,
                    color: _appBarTextColor,
                    songURL:
                        '//open.spotify.com/track/2RlgNHKcydI9sayD2Df2xp?si=7fcab8f35fb44f36',
                    sleepTime: _sleepTime,
                    wakeTime: _wakeTime)
                .add();
            widget._updateSchedules();
            Navigator.of(Get.overlayContext!).pop();
          },
          child: Text('Terminé'))
    ];
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              widget._appBarText,
              style: Theme.of(context)
                  .appBarTheme
                  .titleTextStyle!
                  .copyWith(color: _appBarTextColor),
            )),
        bottomNavigationBar: NavBar(),
        body: Padding(
            padding: EdgeInsets.all(25),
            child: ListView.separated(
                itemCount: _listViewWidgets.length,
                separatorBuilder: (context, index) {
                  var divider = Divider(
                    height: 50,
                    color: Colors.white,
                  );
                  return divider;
                },
                itemBuilder: (context, index) => _listViewWidgets[index])));
  }

  String pickedTimeIntervalToString(PickedTime start, PickedTime end) {
    PickedTime intervalTime = formatIntervalTime(init: start, end: end);
    return '${intervalTime.h}:${intervalTime.m == 0 ? '00' : intervalTime.m}';
  }
}
