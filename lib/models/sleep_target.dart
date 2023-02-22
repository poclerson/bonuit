/// Durée cible de sommeil décidée par l'utilisateur
class SleepTarget {
  static Duration duration = const Duration(hours: 8, minutes: 0);

  static int get hours => duration.inHours;
  static int get minutes => duration.inMinutes.remainder(60);
  static double get total => hours + (minutes / 100);
}

extension DurationExtension on Duration {
  String toStringHoursMinutes() =>
      '${inHours}h${inMinutes.remainder(60).toString().padLeft(2, '0')}';
}
