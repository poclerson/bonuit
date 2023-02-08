import 'package:flutter/material.dart';
import '../../widgets/nav_bar.dart';
import '../../widgets/week_app_bar.dart';
import '../../widgets/size_mesurer.dart';
import 'package:flutter_dash/flutter_dash.dart';
import '../../models/day.dart';
import '../../models/weekday.dart';
import '../../models/time_interval.dart';
import '../../models/sort_method.dart';
import 'stats_group.dart';
import 'sort_method_picker.dart';

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  int weeksOffset = 0;
  final double leftColumnWidth = 50;
  late int amountOfDaysShowing = 28;
  late SortMethod sortMethod = SortMethod('S', (_) {});
  @override
  Widget build(BuildContext context) {
    updateSortMethod(sortMethod) {
      setState(() {
        amountOfDaysShowing = sortMethod.amountOfDays();
      });
    }

    sortMethod = SortMethod(sortMethod.name, updateSortMethod);
    return FutureBuilder(
      future: Day.getAll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TimeInterval timeInterval =
              Day.createIntervals(4, snapshot.data as List<Day>);
          return Scaffold(
              appBar: WeekAppBar(weeksOffset),
              bottomNavigationBar: NavBar(),
              body: Stack(
                children: [
                  Column(
                    children: [
                      /// HEURES
                      Padding(
                        padding: EdgeInsets.fromLTRB(50, 5, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ...timeInterval.intervals.map((temps) => Expanded(
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        temps.toString() + ':00',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      )
                                    ],
                                  ),
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
                              width: leftColumnWidth,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ...Weekday.weekdays.map((weekday) => Text(
                                        weekday[0].toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ))
                                ],
                              ),
                            ),

                            /// CONTENU
                            ChildSizeNotifier((context, size, child) {
                              return Expanded(
                                  child: Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ...timeInterval.intervals
                                          .map((time) => Expanded(
                                                child: Row(children: [
                                                  Dash(
                                                    direction: Axis.vertical,
                                                    length: size.height,
                                                    dashColor: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  )
                                                ]),
                                              ))
                                    ],
                                  ),
                                  PageView(
                                      scrollDirection: Axis.vertical,
                                      onPageChanged: (value) => setState(() {
                                            weeksOffset = value * 7;
                                          }),
                                      children: [
                                        ...snapshot.data!
                                            .groupBySize(amountOfDaysShowing)
                                            .map((dayGroup) => StatsGroup(
                                                dayGroup,
                                                timeInterval,
                                                size.width,
                                                (size.height /
                                                        amountOfDaysShowing *
                                                        .75)
                                                    .clamp(0, 35)))
                                      ]),
                                ],
                              ));
                            }, Container())
                          ],
                        ),
                      )
                    ],
                  ),
                  SortMethodPicker(updateSortMethod)
                ],
              ));
        }
        return Text('Chargement');
      },
    );
  }
}
