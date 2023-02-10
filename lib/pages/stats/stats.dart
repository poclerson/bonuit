import 'package:flutter/material.dart';
import '../../widgets/nav_bar.dart';
import '../../widgets/week_app_bar.dart';
import '../../models/day.dart';
import '../../models/time_interval.dart';
import '../../models/sort_method.dart';
import 'stats_groups.dart';
import 'sort_method_picker.dart';
import 'hours_indicator.dart';
import 'days_indicator.dart';

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  DateTime sortedToDate = DateTime.now();
  late SortMethod byWeek;
  late SortMethod byMonth;
  late SortMethod bySixMonths;
  late SortMethod sortMethod = byWeek;

  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    updateSortMethod(SortMethod newSortMethod) {
      setState(() {
        sortMethod = newSortMethod;
      });
    }

    byWeek = SortMethod.weekdays(
        name: 'S',
        date: sortedToDate,
        onChanged: updateSortMethod,
        startDate: sortedToDate);
    byMonth = SortMethod.dated(
        name: 'M',
        dayAmount: 30,
        date: sortedToDate,
        onChanged: updateSortMethod,
        startDate: sortedToDate);
    bySixMonths = SortMethod.dated(
        name: '6M',
        dayAmount: 180,
        date: sortedToDate,
        onChanged: updateSortMethod,
        startDate: sortedToDate);

    return FutureBuilder(
      future: Day.getAll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TimeInterval timeInterval =
              (snapshot.data as List<Day>).createIntervals(4);
          return Scaffold(
              appBar: DatesAppBar(sortMethod.display(pageIndex)),
              bottomNavigationBar: NavBar(),
              body: Stack(
                children: [
                  Column(
                    children: [
                      /// HEURES
                      HoursIndicator(timeInterval),

                      /// JOURS ET DONNÉES
                      Expanded(
                        child: Row(
                          children: [
                            /// JOURS
                            DaysIndicator(sortMethod),
                            StatsGroups(
                              snapshot.data!,
                              timeInterval: timeInterval,
                              sortMethod: sortMethod,
                              onPageChanged: (pageIndex) => setState(() {
                                this.pageIndex = pageIndex;
                                if (sortMethod.dayAmount != 7)
                                  sortMethod.identifiers =
                                      sortMethod.go(-pageIndex);
                              }),
                            )

                            /// CONTENU
                          ],
                        ),
                      )
                    ],
                  ),
                  SortMethodPicker(
                      [byWeek, byMonth, bySixMonths], updateSortMethod)
                ],
              ));
        }
        return Text('Chargement');
      },
    );
  }
}
