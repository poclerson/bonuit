class SleepTarget {
  late int hours;
  late int minutes;
  static final SleepTarget _instance = SleepTarget._internal();

  factory SleepTarget({required hours, required minutes}) {
    _instance.hours = hours;
    _instance.minutes = minutes;
    return _instance;
  }

  SleepTarget._internal();
}
