import 'schedule.dart';
import 'local_files.dart';
import 'data.dart';
import 'dart:convert';

class Weekday extends Data {
  static var localFile = LocalFiles('weekdays',
      '[{"day": "lundi","schedule" : {}},{"day": "mardi","schedule" : {}},{"day": "mercredi","schedule" : {}},{"day": "jeudi","schedule" : {}},{"day": "vendredi","schedule" : { }},{"day": "samedi","schedule" : {}},{"day": "dimanche","schedule" : {}}]');
  late String day;
  late Schedule? schedule;

  static List<String> weekdays = [
    'lundi',
    'mardi',
    'mercredi',
    'jeudi',
    'vendredi',
    'samedi',
    'dimanche'
  ];

  Weekday(this.day, this.schedule);

  Weekday.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    schedule = json['schedule'].toString() != '{}'
        ? Schedule.fromJson(json['schedule'])
        : Schedule.minimum();
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['schedule'] = schedule!.toJson();
    return data;
  }

  static Future<List<Weekday>> getAll() async {
    final json = await localFile.readAll();

    return json.map((element) => Weekday.fromJson(element)).toList();
  }

  Future<void> changeSchedule(Schedule newSchedule) async {
    final weekdays = await getAll();
    Weekday weekdayToChange =
        weekdays.firstWhere((weekday) => weekday.day == day);
    int index = weekdays.indexOf(weekdayToChange);
    weekdays[index].schedule = newSchedule;
    final json =
        jsonEncode(weekdays.map((weekday) => weekday.toJson()).toList());
    localFile.write(json);
  }

  static onScheduleRemoved(Schedule schedule) async {
    final weekdays = await getAll();

    weekdays.forEach((weekday) {
      if (weekday.schedule!.name == schedule.name) {
        weekday.schedule = Schedule.getBaseCopy();
      }
    });

    await _write(weekdays);
  }

  static onScheduleEdited(Schedule schedule) async {
    final weekdays = await getAll();

    weekdays.forEach((weekday) {
      if (weekday.schedule!.name == schedule.name) {
        weekday.schedule = schedule;
      }
    });

    await _write(weekdays);
  }

  static _write(List<Weekday> weekdays) async {
    localFile.write(
        jsonEncode(weekdays.map((weekday) => weekday.toJson()).toList()));
  }
}
