import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../models/day.dart';

class AverageCircle extends StatelessWidget {
  double _averageHoursSlept;
  String _text;
  AverageCircle(this._averageHoursSlept, this._text);

  late Map<String, double> dataMap = {'fill': _averageHoursSlept};
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(children: [
          PieChart(
            dataMap: dataMap,
            totalValue: 24,
            initialAngleInDegree: 270,
            chartType: ChartType.ring,
            colorList: [Theme.of(context).colorScheme.primary],
            centerText: _averageHoursSlept.toTime(),
            centerTextStyle: Theme.of(context).textTheme.titleLarge,
            legendOptions: LegendOptions(showLegends: false),
            chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: false,
                showChartValues: false,
                showChartValuesInPercentage: false,
                showChartValuesOutside: false),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              _text,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          )
        ]),
      ),
    );
  }
}
