import 'schedule.dart';
import 'local_files.dart';
import 'dart:convert';

class Weekday {
  static var localFile = LocalFiles('weekdays');
  late String day;
  late Schedule schedule;

  Weekday(this.day, this.schedule);

  Weekday.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    schedule = Schedule.fromJson(json['schedule']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['day'] = day;
    data['schedule'] = schedule.toJson();
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
}
