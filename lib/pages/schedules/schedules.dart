import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/date.dart';
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

  late String _appBarText = 'Nouvel horaire';

  late Future<List<Schedule>> _schedules;
  @override
  Widget build(BuildContext context) {
    updateSchedules() {
      setState(() {
        _schedules = Schedule.getAll();
      });
    }

    _schedules = Schedule.getAll();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Semaine du ' +
            DateTime.now()
                .subtract(Duration(days: DateTime.now().weekday - 1))
                .day
                .toString() +
            ' ' +
            Date.months[DateTime(
                        now.year,
                        now.weekday + now.day > amountOfDaysInCurrentMonth
                            ? now.month - 1
                            : now.month,
                        0)
                    .month]
                .toString()),
        backgroundColor: Colors.black,
      ),
      bottomNavigationBar: NavBar(ElevatedButton(
          onPressed: (() {
            // Aller vers la page NewSchedule()
            Get.to(NewSchedule(_appBarText, _schedules, updateSchedules));
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
              future: Weekday.getAll(),
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
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 3,
                            children: [
                              ...snapshot.data!
                                  .map((schedule) => DraggableScheduleBox(
                                      schedule, updateSchedules))
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
