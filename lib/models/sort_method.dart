import 'date.dart';

class SortMethod {
  /// Nom s'affichant dans les widgets
  String name;

  /// Tableau des identifiants permettant de visualiser les données dans un diagramme
  /// En triant par semaine, on ajoute la première lettre de chaque jour de la semaine
  /// En triant par mois/par 6 mois, on ajoute différentes dates
  late List<dynamic> identifiers = [];
  // Quantité de jours dans la méthode de tri
  late int dayAmount;

  /// S'exécute lorsqu'on change de méthode de tri
  late void Function(SortMethod) onChanged;

  /// Là où la méthode de tri commence à compter les dates (pour le triage par mois/6 mois)
  late DateTime startDate;

  static int weekly = 7;
  static int monthly = 30;
  static int sixMonthly = 180;

  SortMethod(this.name, this.dayAmount);

  /// Remplit `identifiers` à partir d'intervalles de dates
  SortMethod.dated(
      {required this.name,
      required this.dayAmount,
      required DateTime date,
      required this.onChanged,
      required this.startDate,
      int intervalAmount = 7}) {
    identifiers = createIntervals(date, intervalAmount);
  }

  /// Remplit `identifiers` à partir des premières lettres des jours de la semaine
  SortMethod.weekdays(
      {required this.name,
      this.dayAmount = 7,
      required DateTime date,
      required this.onChanged,
      required this.startDate}) {
    identifiers.addAll(Date.weekdays.getRange(date.weekday - 1, weekly));
    identifiers.addAll(Date.weekdays.getRange(0, date.weekday - 1));
    identifiers = identifiers
        .map((identifier) => (identifier[0] as String).toUpperCase())
        .toList();
  }

  /// Crée une `List` des intervalles de date, où
  /// `from` est la date de début et `intervalAmount` la quantité d'intervalles
  /// à afficher
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

  /// Montre le texte dans l'`appBar` d'une page permettant de savoir
  /// à quel point on se situe dans le temps
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
