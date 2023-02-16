import 'schedule.dart';
import 'local_files.dart';
import 'data.dart';
import 'notifications.dart';
import 'date.dart';

class Weekday extends Data {
  static LocalFiles localFile = LocalFiles('weekdays', [
    {
      "day": "lundi",
      "sleepNotificationID": null,
      "wakeNotificationID": null,
      "schedule": null
    },
    {
      "day": "mardi",
      "sleepNotificationID": null,
      "wakeNotificationID": null,
      "schedule": null
    },
    {
      "day": "mercredi",
      "sleepNotificationID": null,
      "wakeNotificationID": null,
      "schedule": null
    },
    {
      "day": "jeudi",
      "sleepNotificationID": null,
      "wakeNotificationID": null,
      "schedule": null
    },
    {
      "day": "vendredi",
      "sleepNotificationID": null,
      "wakeNotificationID": null,
      "schedule": null
    },
    {
      "day": "samedi",
      "sleepNotificationID": null,
      "wakeNotificationID": null,
      "schedule": null
    },
    {
      "day": "dimanche",
      "sleepNotificationID": null,
      "wakeNotificationID": null,
      "schedule": null
    }
  ]);
  late String day;
  late Schedule? schedule;
  late int? sleepNotificationID;
  late int? wakeNotificationID;

  Weekday.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    schedule =
        json['schedule'] != null ? Schedule.fromJson(json['schedule']) : null;
    sleepNotificationID = json['sleepNotificationID'];
    wakeNotificationID = json['wakeNotificationID'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['schedule'] = schedule != null ? schedule!.toJson() : null;
    data['sleepNotificationID'] = sleepNotificationID;
    data['wakeNotificationID'] = wakeNotificationID;
    return data;
  }

  toNull() {
    schedule = null;
    sleepNotificationID = null;
    wakeNotificationID = null;
  }

  onScheduleAddedOrChanged(Schedule newSchedule) async {
    final weekdays = await getAll();
    schedule = newSchedule;
    Weekday weekdayToChange =
        weekdays.firstWhere((weekday) => weekday.day == day);
    int index = weekdays.indexOf(weekdayToChange);
    weekdays[index] = this;

    sleepNotificationID = await Notifications.add(
        options: Notifications.sleep,
        weekday: Date.weekdays.indexOf(day) + 1,
        time: schedule!.sleepTime);

    Data.write(weekdays, localFile);
  }

  onScheduleRemoved() async {
    final weekdays = await getAll();

    weekdays.firstWhere((weekday) => weekday.day == day).toNull();

    await Data.write(weekdays, localFile);
  }

  static Future<List<Weekday>> getAll() async {
    final json = await localFile.readAll();

    return json.map((element) => Weekday.fromJson(element)).toList();
  }

  static onScheduleDeleted(Schedule schedule) async {
    final weekdays = await getAll();

    weekdays.forEach((weekday) {
      if (weekday.schedule != null &&
          (weekday.schedule!.name == schedule.name)) {
        weekday.toNull();
      }
    });

    await Data.write(weekdays, localFile);
  }

  static onScheduleEdited(Schedule editedSchedule) async {
    final weekdays = await getAll();

    weekdays.forEach((weekday) async {
      if (weekday.schedule != null) {
        if (weekday.schedule!.name == editedSchedule.name) {
          weekday.schedule = editedSchedule;

          Notifications.delete(weekday.sleepNotificationID!);

          weekday.sleepNotificationID = await Notifications.add(
              options: Notifications.sleep, time: weekday.schedule!.sleepTime);
        }
      }
    });

    await Data.write(weekdays, localFile);
  }
}
