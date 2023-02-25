import 'package:flutter/material.dart';
import '../../models/sleep_target.dart';
import '../../widgets/nav_bar.dart';
import '../../widgets/color_picker.dart';
import 'sound_picker.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import '../../widgets/text_prompt.dart';
import '../../models/schedule.dart';
import '../../models/weekday.dart';
import '../../models/sound.dart';
import '../../models/time_slept.dart';
import 'dart:core';
import 'package:get/get.dart';
import 'app_circle_time_picker.dart';
import '../../models/time_of_day_extension.dart';
import 'package:separated_column/separated_column.dart';
import 'new_schedule_section.dart';

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
    _sleepTime = widget.schedule.sleepTime.toPickedTime();
    _wakeTime = widget.schedule.wakeTime.toPickedTime();

    /// Ajouter le Prompt aux fonctions ouvertes onLoad
    WidgetsBinding.instance
        .addPostFrameCallback(widget.schedule.name == Schedule.baseName
            ? (_) => showDialog(
                context: context,
                builder: (context) => TextPrompt(
                      (value) async {
                        final schedules = await Schedule.all;
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
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              widget.schedule.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: widget.schedule.color),
            )),
        bottomNavigationBar: NavBar(),
        body: Padding(
            padding: EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: SeparatedColumn(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  separatorBuilder: (context, index) => Divider(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                  children: [
                    /// TimePicker
                    NewScheduleSection(title: 'Temps de sommeil', content: [
                      AppCircleTimePicker(widget.schedule,
                          onSelectionChanged: (sleep, wake, isDisableRange) =>
                              setState(() {
                                widget.schedule.sleepTime =
                                    TimeOfDayExtension.fromPickedTime(sleep);
                                widget.schedule.wakeTime =
                                    TimeOfDayExtension.fromPickedTime(wake);
                              }),
                          onSelectionEnded: ((sleep, wake, isDisableRange) =>
                              setState(() {
                                _sleepTime = sleep;
                                _wakeTime = wake;
                              }))),
                      if (widget.schedule.hoursSlept < SleepTarget.total)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Il vous manque ${(SleepTarget.total - widget.schedule.hoursSlept).toTimeOfDay().toStringFormatted('h')} pour atteindre votre objectif de sommeil',
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextButton(
                                onPressed: () => Get.toNamed('/settings'),
                                child: Text('Modifier dans préférences'))
                          ],
                        )
                      else
                        Text(
                          'Vous atteignez votre objectif de sommeil',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                    ]),

                    /// ColorPicker
                    NewScheduleSection(title: 'Couleur', content: [
                      ColorPicker((Color color) {
                        setState(() {
                          widget.schedule.color = color;
                        });
                      }),
                    ]),

                    /// SoundPicker (sleep)
                    NewScheduleSection(title: 'Son de coucher', content: [
                      SoundPicker(
                        defaultSoundFilePath:
                            widget.operation == Operation.addition
                                ? null
                                : widget.schedule.sleepSound,
                        sounds: Sound.sleep,
                        onSoundPicked: ((sound) {
                          setState(() {
                            widget.schedule.sleepSound = sound.fileName;
                            widget.updateSchedules();
                          });
                        }),
                      ),
                    ]),

                    /// SoundPicker (wake)
                    NewScheduleSection(title: 'Son de lever', content: [
                      SoundPicker(
                        defaultSoundFilePath:
                            widget.operation == Operation.addition
                                ? null
                                : widget.schedule.wakeSound,
                        sounds: Sound.wake,
                        onSoundPicked: ((sound) {
                          setState(() {
                            widget.schedule.wakeSound = sound.fileName;
                            widget.updateSchedules();
                          });
                        }),
                      ),
                    ]),

                    /// Buttons
                    NewScheduleSection(content: [
                      TextButton(
                          onPressed: () async {
                            switch (widget.operation) {
                              case Operation.addition:
                                await Schedule.pickedTime(
                                        name: widget.schedule.name,
                                        color: widget.schedule.color,
                                        sleepSound: widget.schedule.sleepSound,
                                        wakeSound: widget.schedule.wakeSound,
                                        sleepTime: _sleepTime,
                                        wakeTime: _wakeTime)
                                    .add();
                                break;
                              case Operation.edition:
                                await widget.oldSchedule.edit(
                                    Schedule.pickedTime(
                                        name: widget.schedule.name,
                                        color: widget.schedule.color,
                                        sleepSound: widget.schedule.sleepSound,
                                        wakeSound: widget.schedule.wakeSound,
                                        sleepTime: _sleepTime,
                                        wakeTime: _wakeTime));
                                Weekday.onScheduleEdited(widget.oldSchedule);
                                widget.updateWeekdays!();
                            }
                            widget.updateSchedules();
                            Navigator.of(Get.overlayContext!).pop();
                            await Sound.stop();
                          },
                          child: Text('Terminé')),
                      SizedBox(
                        height: 20,
                      ),
                      if (widget.operation == Operation.edition)
                        TextButton(
                            style: Theme.of(context)
                                .textButtonTheme
                                .style!
                                .copyWith(
                                    backgroundColor: MaterialStatePropertyAll<
                                            Color>(
                                        Theme.of(context).colorScheme.error),
                                    foregroundColor: MaterialStatePropertyAll<
                                            Color>(
                                        Theme.of(context).colorScheme.onError)),
                            onPressed: () async {
                              await widget.schedule.delete();
                              await Weekday.onScheduleDeleted(widget.schedule);
                              widget.updateSchedules();
                              widget.updateWeekdays!();
                              Navigator.of(Get.overlayContext!).pop();
                              await Sound.stop();
                            },
                            child: Text('Supprimer'))
                    ])
                  ]),
            )));
  }
}
