class Hour {
  static String now([bool? useColumn]) {
    DateTime now = DateTime.now();
    String separator = 'h';

    if (useColumn == true) separator = ':';

    return now.hour.toString() + separator + now.hour.toString();
  }
}
