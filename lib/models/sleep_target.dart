import 'data.dart';
import 'local_files.dart';
import 'package:flutter/material.dart';
import 'time_of_day_extension.dart';

/// Durée cible de sommeil décidée par l'utilisateur
class SleepTarget extends Data {
  // Singleton
  static final SleepTarget _instance = SleepTarget._internal();

  factory SleepTarget() {
    return _instance;
  }

  SleepTarget._internal();
  late TimeOfDay duration;
  static LocalFiles localFile = LocalFiles('sleep-target', [
    {'sleepTarget': 8}
  ]);

  static JSONManager<SleepTarget> json = JSONManager(
      localFile: localFile,
      constructor: ((json) => SleepTarget.fromJson(json)));

  SleepTarget.fromJson(Map<String, dynamic> json) {
    duration = (json['sleepTarget'].toDouble() as double).toTimeOfDay();
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sleepTarget'] = SleepTarget().duration.toDouble();
    return data;
  }

  setDuration(TimeOfDay duration) {
    SleepTarget().duration = duration;

    json.edit(to: SleepTarget());
  }

  static initialize() async {
    SleepTarget().duration = (await json.all)[0].duration;
  }
}

extension DurationExtension on Duration {
  String toStringHoursMinutes() =>
      '${inHours}h${inMinutes.remainder(60).toString().padLeft(2, '0')}';
}
