import 'package:flutter/material.dart';
import '../../models/date.dart';
import '../../models/schedule.dart';

import '../../styles.dart';

import '../../widgets/nav_bar.dart';
import '../../widgets/title_display.dart';
import 'weekday.dart';
import 'draggable_schedule_box.dart';

List<String> horaires = ['Travail', 'Maison', 'Bureau', 'École'];

class Schedules extends StatefulWidget {
  @override
  _SchedulesState createState() => _SchedulesState();
}

class _SchedulesState extends State<Schedules> {
  List<Schedule> _schedules = [];

  @override
  Widget build(BuildContext context) {
    Schedule.getAllSchedules().then((value) => _schedules.addAll(value));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Semaine du ' +
            DateTime.now().day.toString() +
            ' ' +
            Date.months[DateTime.now().month]),
        backgroundColor: Colors.black,
      ),
      bottomNavigationBar: NavBar(Icon(
        Icons.add_box_rounded,
        size: 50,
      )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 100),
            child: TitleDisplay.styleWith(
                "Modifier l'horaire", DisplayTextStyleSmall),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              ...Date.weekdays.map((day) => Weekday(day, Colors.red)).toList()
            ],
          ),
          Wrap(
            children: [
              ..._schedules.map((schedule) =>
                  DraggableScheduleBox(schedule.name, schedule.color))
            ],
          )
        ],
      ),
    );
  }
}
