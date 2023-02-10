import 'package:flutter/material.dart';
import '../../models/time_interval.dart';

class HoursIndicator extends StatelessWidget {
  TimeInterval _timeInterval;
  HoursIndicator(this._timeInterval);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(50, 5, 0, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ..._timeInterval.intervals.map((temps) => Expanded(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      temps.toString() + ':00',
                      style: Theme.of(context).textTheme.titleSmall,
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
