import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBar extends StatelessWidget {
  final Widget _title;
  NavBar([this._title = const Text('')]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [BackButton(), _title]),
      ),
    );
  }
}
