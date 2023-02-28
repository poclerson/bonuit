import 'package:flutter/material.dart';
import '../../widgets/nav_bar.dart';
import '../../widgets/week_app_bar.dart';
import '../../models/sleep_day.dart';
import '../../models/time_interval.dart';
import '../../models/sort_method.dart';
import 'stats_groups.dart';
import 'sort_method_picker.dart';
import 'hours_indicator.dart';
import 'days_indicator.dart';

class Stats extends StatefulWidget {
  int _defaultSortMethodDayAmount;
  Stats([this._defaultSortMethodDayAmount = 7]);
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  DateTime sortedToDate = DateTime.now();

  updateSortMethod(SortMethod newSortMethod) {
    setState(() {
      sortMethod = newSortMethod;
    });
  }

  int pageIndex = 0;
  late SortMethod sortMethod = [byWeek, byMonth, bySixMonths].firstWhere(
      (sortMethod) =>
          sortMethod.dayAmount == widget._defaultSortMethodDayAmount);
  late SortMethod byWeek = SortMethod.weekdays(
      name: 'S',
      date: sortedToDate,
      onChanged: updateSortMethod,
      startDate: sortedToDate);
  late SortMethod byMonth = SortMethod.dated(
      name: 'M',
      dayAmount: SortMethod.monthly,
      date: sortedToDate,
      onChanged: updateSortMethod,
      startDate: sortedToDate);
  late SortMethod bySixMonths = SortMethod.dated(
      name: '6M',
      dayAmount: SortMethod.sixMonthly,
      date: sortedToDate,
      onChanged: updateSortMethod,
      startDate: sortedToDate);

  late TimeInterval timeInterval;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SleepDay.json.all,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          timeInterval = TimeInterval(days: snapshot.data!, intervalAmount: 4);
          return Scaffold(
              appBar: DatesAppBar(sortMethod.display(pageIndex)),
              bottomNavigationBar: NavBar(
                child: SortMethodPicker(
                    [byWeek, byMonth, bySixMonths],
                    [byWeek, byMonth, bySixMonths].indexOf(sortMethod),
                    updateSortMethod),
                alignment: MainAxisAlignment.center,
              ),
              body: Stack(
                alignment: Alignment.center,
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
                                if (sortMethod.dayAmount != 7) {
                                  sortMethod.identifiers = sortMethod
                                      .createIntervalsFormatted(-pageIndex);
                                }
                              }),
                            )

                            /// CONTENU
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ));
        }
        return Text('Chargement');
      },
    );
  }
}
