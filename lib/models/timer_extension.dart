import 'dart:async';

extension TimerExtension on Timer {
  static Map<int, Timer> timers = {};

  static create(int id, Duration duration, Function(Timer) callback) {
    timers[id] = Timer.periodic(duration, callback);
  }

  static delete(int id) {
    timers[id]!.cancel();
    timers.removeWhere((key, value) => key == id);
  }
}
