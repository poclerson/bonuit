import 'package:flutter/material.dart';
import '../../widgets/nav_bar.dart';
import '../../widgets/colorpicker.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import '../../widgets/text_prompt.dart';
import '../../models/schedule.dart';
import '../../models/weekday.dart';
import 'dart:core';
import 'package:get/get.dart';
import '../../models/time.dart';

class NewSchedule extends StatefulWidget {
  Schedule schedule;
  Function updateSchedules;
  Function? updateWeekdays;
  Operation operation;
  late Schedule oldSchedule = schedule;
  NewSchedule(
      {required this.updateSchedules,
      required this.schedule,
      required this.operation,
      this.updateWeekdays});

  @override
  _NewScheduleState createState() => _NewScheduleState();
}

class _NewScheduleState extends State<NewSchedule> {
  late PickedTime _sleepTime;
  late PickedTime _wakeTime;

  @override
  Widget build(BuildContext context) {
    _sleepTime = widget.schedule.sleepTime!.toPickedTime();
    _wakeTime = widget.schedule.wakeTime!.toPickedTime();

    /// Ajouter le Prompt aux fonctions ouvertes onLoad
    WidgetsBinding.instance.addPostFrameCallback(widget.schedule.isBase()
        ? (_) => showDialog(
            context: context,
            builder: (context) => TextPrompt(
                  (value) async {
                    final schedules = await Schedule.getAll();
                    bool nameExists =
                        schedules.any((schedule) => schedule.name == value);
                    if (!nameExists) {
                      setState(() {
                        widget.schedule.name = value;
                      });
                    }
                    return nameExists;
                  },
                ))
        : (_) {});

    /// Widgets à être instantiés dans le ListView
    List<Widget> _listViewWidgets = [
      Text(
        'Couleur',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      ColorPicker((Color color) {
        setState(() {
          widget.schedule.color = color;
        });
      }),
      Text(
        'Temps de sommeil',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      TimePicker(
        initTime: widget.schedule.sleepTime!.toPickedTime(),
        endTime: widget.schedule.wakeTime!.toPickedTime(),
        onSelectionChange: (sleep, wake, isDisableRange) {
          setState(() {
            widget.schedule.sleepTime = Time.fromPickedTime(sleep);
            widget.schedule.wakeTime = Time.fromPickedTime(wake);
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
            widget.schedule.timeInterval(),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ),
      OutlinedButton(
          onPressed: () {
            if (widget.operation == Operation.addition) {}
            switch (widget.operation) {
              case Operation.addition:
                Schedule.pickedTime(
                        name: widget.schedule.name,
                        color: widget.schedule.color,
                        songURL:
                            '//open.spotify.com/track/2RlgNHKcydI9sayD2Df2xp?si=7fcab8f35fb44f36',
                        sleepTime: _sleepTime,
                        wakeTime: _wakeTime)
                    .add();
                break;
              case Operation.edition:
                Function edit = widget.oldSchedule.edit;
                edit(Schedule.pickedTime(
                    name: widget.schedule.name,
                    color: widget.schedule.color,
                    songURL:
                        '//open.spotify.com/track/2RlgNHKcydI9sayD2Df2xp?si=7fcab8f35fb44f36',
                    sleepTime: _sleepTime,
                    wakeTime: _wakeTime));
                debugPrint(widget.schedule!.color.toString());
                Weekday.onScheduleEdited(widget.schedule);
                widget.updateWeekdays!();
            }
            widget.updateSchedules();
            Navigator.of(Get.overlayContext!).pop();
          },
          child: Text('Terminé'))
    ];
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              widget.schedule.name!,
              style: Theme.of(context)
                  .appBarTheme
                  .titleTextStyle!
                  .copyWith(color: widget.schedule.color),
            )),
        bottomNavigationBar: NavBar(),
        body: Padding(
            padding: EdgeInsets.all(25),
            child: ListView.separated(
                itemCount: _listViewWidgets.length,
                separatorBuilder: (context, index) {
                  var divider = Divider(
                    height: 50,
                    color: Theme.of(context).colorScheme.onBackground,
                  );
                  return divider;
                },
                itemBuilder: (context, index) => _listViewWidgets[index])));
  }
}
