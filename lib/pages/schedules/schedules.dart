import 'package:flutter/material.dart';
import 'package:sommeil/models/weekday.dart';
import '../../models/date.dart';
import '../../models/schedule.dart';

import '../../styles.dart';

import '../../widgets/nav_bar.dart';
import '../../widgets/title_display.dart';
import 'weekday_block.dart';
import 'draggable_schedule_box.dart';

class Schedules extends StatefulWidget {
  @override
  _SchedulesState createState() => _SchedulesState();
}

class _SchedulesState extends State<Schedules> {
  List<Schedule> _schedules = [];
  List<Weekday> _weekdays = [];

  @override
  Widget build(BuildContext context) {
    Future<void> readJson() async {
      // final weekdays = await Weekday.getAll();
      final schedules = await Schedule.getAll();
      setState(() {
        // _weekdays = weekdays;
        _schedules = schedules;
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Semaine du ' +
            DateTime.now().day.toString() +
            ' ' +
            Date.months[DateTime.now().month]),
        backgroundColor: Colors.black,
      ),
      bottomNavigationBar: NavBar(ElevatedButton(
          onPressed: (() => Schedule('name', Colors.black, 'songURL',
                  DateTime.now(), DateTime.now())
              .add()),
          child: Icon(Icons.add))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 100),
            child: TitleDisplay.styleWith(
                "Modifier l'horaire", DisplayTextStyleSmall),
          ),
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
              future: Schedule.getAll(),
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
                                  .map((schedule) =>
                                      DraggableScheduleBox(schedule))
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
