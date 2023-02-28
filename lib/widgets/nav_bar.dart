import 'package:flutter/material.dart';
import '../models/sound.dart';
import 'package:get/get.dart';

class NavBar extends StatelessWidget {
  final Widget child;
  final MainAxisAlignment alignment;
  NavBar(
      {this.child = const Text(''),
      this.alignment = MainAxisAlignment.spaceBetween});
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Container(
      padding: EdgeInsets.all(15),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        BackButton(
          onPressed: () async {
            Navigator.of(Get.overlayContext!).pop();
            await Sound.stop();
          },
        ),
        child,
        if (alignment != MainAxisAlignment.spaceBetween)
          SizedBox(
            width: 50,
          )
      ]),
    ));
  }
}
