import 'package:flutter/material.dart';

class StatsDay extends StatelessWidget {
  final Size size;
  final double offset;
  StatsDay({required this.size, required this.offset});

  @override
  Widget build(BuildContext context) {
    // debugPrint('${size.width}, $offset');
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      margin: EdgeInsets.only(left: offset > 0 ? offset : 0),
      width: size.width > 0 ? size.width : 0,
      height: size.height,
    );
  }
}
