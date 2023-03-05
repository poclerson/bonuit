import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/weekday.dart';
import '../../models/schedule.dart';

import '../../widgets/nav_bar.dart';
import '../new_schedule/new_schedule.dart';
import 'weekday_block.dart';
import 'draggable_schedule_box.dart';

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
        _schedules = Schedule.json.all;
      });
    }

    updateWeekdays() {
      setState(() {
        _weekdays = Weekday.json.all;
      });
    }

    _schedules = Schedule.json.all;
    _weekdays = Weekday.json.all;

    return Scaffold(
      bottomNavigationBar: NavBar(
          child: Container(
        width: 60,
        height: 60,
        child: ElevatedButton(
            onPressed: (() => Get.to(NewSchedule(
                  updateSchedules: updateSchedules,
                  schedule:
                      Schedule.base(Theme.of(context).colorScheme.primary),
                  operation: Operation.addition,
                ))),
            child: Text(
              '+',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 40,
                  color: Theme.of(context).colorScheme.background),
            )),
      )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.only(top: 125, bottom: 50),
              child: Text(
                "Modifier l'horaire",
                style: Theme.of(context).textTheme.displayMedium,
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
                          .map((weekday) => WeekdayBlock(
                                weekday: weekday,
                                defaultColor:
                                    Theme.of(context).colorScheme.onBackground,
                                updateWeekdays: updateWeekdays,
                              ))
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
                    height:
                        (MediaQuery.of(context).size.width / 3).clamp(0, 200),
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.all(5),
                          sliver: SliverGrid.count(
                            crossAxisCount: 1,
                            childAspectRatio:
                                MediaQuery.of(context).size.width > 700
                                    ? 1
                                    : 1 / 1.35,
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
