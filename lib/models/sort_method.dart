import 'date.dart';

class SortMethod {
  String name;
  late List<dynamic> identifiers = [];
  late int dayAmount;
  void Function(SortMethod) onChanged;
  DateTime startDate;

  SortMethod.dated(
      {required this.name,
      required this.dayAmount,
      required DateTime date,
      required this.onChanged,
      required this.startDate,
      int intervalAmount = 7}) {
    identifiers = createIntervals(date, intervalAmount);
  }

  SortMethod.weekdays(
      {required this.name,
      this.dayAmount = 7,
      required DateTime date,
      required this.onChanged,
      required this.startDate}) {
    for (var i = date.weekday; i <= 7; i++) {
      identifiers.add(Date.weekdays[i - 1][0].toUpperCase());
    }
    for (var i = 0; i <= 7 - identifiers.length + 1; i++) {
      identifiers.add(Date.weekdays[i][0].toUpperCase());
    }
  }

  List<dynamic> createIntervals(DateTime from, int intervalAmount) {
    List<dynamic> intervals = [];

    int intervalLength = (dayAmount / intervalAmount).round();

    for (var i = 0; i < dayAmount; i += intervalLength) {
      intervals.add(DateTime(from.year, from.month, from.day - i));
    }

    return intervals;
  }

  List<dynamic> go(int distance) {
    return createIntervals(
        DateTime(startDate.year, startDate.month,
            startDate.day + distance * dayAmount),
        7);
  }

  String display(int distance) {
    if (dayAmount == 7) {
      switch (distance) {
        case 0:
          return 'Cette semaine';
        case 1:
          return 'Semaine dernière';
        default:
          return 'Il y a $distance semaines';
      }
    }
    if (dayAmount == 30) {
      switch (distance) {
        case 0:
          return 'Ce mois-ci';
        case 1:
          return 'Mois dernier';
        default:
          return 'Il y a $distance mois';
      }
    }
    if (go(distance).first is DateTime && go(distance).last is DateTime) {
      return 'Du ' +
          (go(distance).last as DateTime).toFrench() +
          ' au ' +
          (go(distance).first as DateTime).toFrench();
    }
    return '';
  }
}

extension DateTimeExtension on DateTime {
  String toFrench([int monthCharLimit = -1, String separator = '']) {
    return '$day$separator ${Date.months[month - 1].substring(0, monthCharLimit > 0 ? monthCharLimit : Date.months[month - 1].length)}';
  }
}
