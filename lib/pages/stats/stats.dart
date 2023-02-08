import 'package:flutter/material.dart';
import '../../widgets/nav_bar.dart';
import '../../widgets/week_app_bar.dart';
import '../../widgets/size_mesurer.dart';
import '../../models/day.dart';
import '../../models/weekday.dart';
import '../../models/time_interval.dart';
import 'stats_day.dart';
import 'stats_week.dart';

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  int weeksOffset = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([Day.getAll(), Weekday.getAll()]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TimeInterval timeInterval =
              Day.createIntervals(4, snapshot.data![0] as List<Day>);
          return Scaffold(
            appBar: WeekAppBar(weeksOffset),
            bottomNavigationBar: NavBar(),
            body: Column(
              children: [
                /// HEURES
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 5, 5, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...timeInterval.intervals.map((temps) => Text(
                            temps.toString() + ':00',
                            style: Theme.of(context).textTheme.titleSmall,
                          ))
                    ],
                  ),
                ),

                /// JOURS ET DONNÉES
                Expanded(
                  child: Row(
                    children: [
                      /// JOURS
                      Container(
                        width: 40,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ...snapshot.data![1].map((weekday) => Text(
                                  (weekday as Weekday).day[0].toUpperCase(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ))
                          ],
                        ),
                      ),

                      /// CONTENU
                      ChildSizeNotifier((context, size, child) {
                        List<Widget> daysToWeeks(List<Day> days) {
                          late List<Day> daysInCurrentWeek = [];
                          late List<StatsWeek> weeks = [];
                          for (var i = 0; i < days.length; i++) {
                            Day currentDay = days[i];
                            daysInCurrentWeek.add(currentDay);
                            if ((i + 1) % 7 == 0) {
                              weeks.add(StatsWeek(daysInCurrentWeek
                                  .map((day) =>
                                      StatsDay(day, timeInterval, size.width))
                                  .toList()));
                              daysInCurrentWeek.clear();
                            }
                          }
                          return weeks;
                        }

                        return Expanded(
                            child: Container(
                          padding: EdgeInsets.all(20),
                          child: PageView(
                            scrollDirection: Axis.vertical,
                            onPageChanged: (value) => setState(() {
                              weeksOffset = value * 7;
                            }),
                            children: [
                              ...daysToWeeks(snapshot.data![0] as List<Day>)
                            ],
                          ),
                        ));
                      }, Container())
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return Text('Chargement');
      },
    );
  }
}
