import 'date.dart';
import 'package:flutter/material.dart';

class SortMethod {
  String name;
  late List<String> identifiers = [];
  late int dayAmount;
  late void Function(SortMethod) onChanged;

  static DateTime date = DateTime.now();

  SortMethod({required this.name, required this.identifiers}) {
    dayAmount = identifiers.length;
  }

  SortMethod.dated(
      {required this.name,
      required this.dayAmount,
      required DateTime date,
      int intervalAmount = 7}) {
    identifiers = createIntervals(date, intervalAmount);
  }

  SortMethod.weekdays(
      {required this.name, this.dayAmount = 7, required DateTime date}) {
    for (var i = date.weekday; i <= 7; i++) {
      identifiers.add(Date.weekdays[i - 1][0]);
    }
    for (var i = 0; i <= 7 - identifiers.length + 1; i++) {
      identifiers.add(Date.weekdays[i][0]);
    }
  }

  static SortMethod byWeek = SortMethod.weekdays(name: 'S', date: date);
  static SortMethod byMonth =
      SortMethod.dated(name: 'M', dayAmount: 30, date: date);
  static SortMethod bySixMonths =
      SortMethod.dated(name: '6M', dayAmount: 180, date: date);

  static List<SortMethod> methods = [byWeek, byMonth, bySixMonths];

  List<String> createIntervals(DateTime from, int intervalAmount) {
    List<String> intervals = [];

    int intervalLength = (dayAmount / intervalAmount).round();

    for (var i = 0; i < dayAmount; i += intervalLength) {
      DateTime current = DateTime(from.year, from.month, from.day - i);
      intervals.add(current.day.toString() +
          Date.months[current.month - 1].toString()[0]);
    }
    debugPrint(intervals[0]);

    return intervals;
  }
}

extension SortMethodListExtension on List<SortMethod> {
  attributeOnChangedFunctions(void Function(SortMethod) newOnChanged) {
    SortMethod.methods
        .forEach((sortMethod) => sortMethod.onChanged = newOnChanged);
  }
}
