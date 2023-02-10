import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/date.dart';
import '../../models/weekday.dart';
import '../../models/schedule.dart';

import '../../widgets/nav_bar.dart';
import '../new_schedule/new_schedule.dart';
import 'weekday_block.dart';
import 'draggable_schedule_box.dart';
import '../../widgets/choices_prompt.dart';
import '../../widgets/week_app_bar.dart';

class Schedules extends StatefulWidget {
  @override
  _SchedulesState createState() => _SchedulesState();
}

class _SchedulesState extends State<Schedules> {
  DateTime now = DateTime.now();
  late int amountOfDaysInCurrentMonth =
      DateTime(now.year, now.month + 1, 0).day;

  late Future<List<Schedule>> _schedules;
  late Future<List<Weekday>> _weekdays;
  @override
  Widget build(BuildContext context) {
    updateSchedules() {
      setState(() {
        _schedules = Schedule.getAll();
      });
    }

    updateWeekdays() {
      setState(() {
        _weekdays = Weekday.getAll();
      });
    }

    _schedules = Schedule.getAll();
    _weekdays = Weekday.getAll();
    return Scaffold(
      bottomNavigationBar: NavBar(ElevatedButton(
          onPressed: (() {
            // Aller vers la page NewSchedule()
            Get.to(NewSchedule(
              updateSchedules: updateSchedules,
              schedule: Schedule.getBaseCopy(),
              operation: Operation.addition,
            ));
            setState(() {});
          }),
          child: Icon(Icons.add))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 50, top: 50),
              child: Text(
                "Modifier l'horaire",
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              )),
          FutureBuilder(
              future: _weekdays,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      ...snapshot.data!
                          .map((weekday) => WeekdayBlock(weekday))
                          .toList()
                    ],
                  );
                } else {
                  return Wrap(
                    alignment: WrapAlignment.center,
                    children: [Text('Pas encore chargé')],
                  );
                }
              }),
          FutureBuilder(
              future: _schedules,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 3,
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.all(0),
                          sliver: SliverGrid.count(
                            crossAxisCount: 1,
                            childAspectRatio: 1 / 1.5,
                            children: [
                              ...snapshot.data!
                                  .map((schedule) => DraggableScheduleBox(
                                        schedule: schedule,
                                        onEdited: () {
                                          Get.to(NewSchedule(
                                            schedule: schedule,
                                            updateSchedules: updateSchedules,
                                            updateWeekdays: updateWeekdays,
                                            operation: Operation.edition,
                                          ));
                                        },
                                        onDeleted: () {
                                          showDialog(
                                              context: context,
                                              builder: ((context) =>
                                                  ChoicesPrompt(() async {
                                                    await schedule.delete();
                                                    await Weekday
                                                        .onScheduleRemoved(
                                                            schedule);
                                                    updateSchedules();
                                                    updateWeekdays();
                                                  })));
                                        },
                                      ))
                                  .toList()
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Wrap(
                    alignment: WrapAlignment.center,
                    children: [Text('Pas encore chargé')],
                  );
                }
              }),
        ],
      ),
    );
  }
}
