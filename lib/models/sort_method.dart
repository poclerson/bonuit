class SortMethod {
  String name;
  Function(SortMethod) onChanged;

  SortMethod(this.name, this.onChanged);

  Map<String, int> _amountOfDaysInMethods = {
    'S': 7,
    'M': DateTime.now().daysInMonth(),
    '6M': DateTime.now().daysInMonths(6)
  };

  int amountOfDays() => _amountOfDaysInMethods[name]!;
}

extension DateTimeExtension on DateTime {
  int daysInMonth() {
    return DateTime(year, month + 1, 0).day;
  }

  int daysInMonths(int amountOfMonths) {
    int amountOfDays = 0;

    for (var i = 0; i < amountOfMonths; i++) {
      amountOfDays += DateTime(year, month + 1 + i, 0).daysInMonth();
    }

    return amountOfDays;
  }
}
