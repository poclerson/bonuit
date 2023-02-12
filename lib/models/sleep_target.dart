class SleepTarget {
  static Duration duration = const Duration(hours: 8, minutes: 0);

  static int get hours => duration.inHours;
  static int get minutes => duration.inMinutes.remainder(60);
}

extension DurationExtension on Duration {
  String toStringHoursMinutes() =>
      '${inHours}h${inMinutes.remainder(60).toString().padLeft(2, '0')}';
}
