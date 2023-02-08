import 'package:get/get.dart';

import 'day.dart';
import 'package:flutter/material.dart';

class TimeInterval {
  final int length;
  final int totalLength;
  final List<int> intervals;

  TimeInterval(this.length, this.totalLength, this.intervals);

  double timeToRatio(double time, double ratioer) {
    return ratioer * time / totalLength.toDouble();
  }

  /// Retourne l'intervalle la plus simlaire à [value] dans [intervals]
  int mostSimilarIntervalTo(int value) {
    // Map<interval, différence>
    Map<int, int> differences = {};
    intervals.forEach(
        (interval) => differences[interval] = (interval - value).abs());
    // Trouver la différence la plus petite, ce qui revient à trouver la valeur la plus proche
    int mostSimilar = differences.entries
        .reduce((current, next) => current.value < next.value ? current : next)
        .key;
    return mostSimilar;
  }

  /// Trouve l'intervalle la plus similaire avec [mostSimilarTo]
  /// et applique [offset] d'après [ratio]
  double ratioedOffset(TimeOfDay offset, double ratio) {
    int unOffsettedValue = mostSimilarIntervalTo(offset.toInt());
    double difference = offset.toDouble() - unOffsettedValue.toDouble();
    double ratioed = timeToRatio(
        intervals.indexOf(unOffsettedValue) * length.toDouble() + difference,
        ratio);
    if (ratioed < 0) return 0;
    return ratioed;
  }
}
