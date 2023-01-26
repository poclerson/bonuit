import 'package:flutter/material.dart';
import '../data/screens.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(screens.length);
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          BackButton(),
          ...screens.map((screen) => screen.name).map((name) => GestureDetector(
                child: Text(name),
                onTap: () => _onNavElementTap(context, name),
              ))
        ]),
      ),
    );
  }

  _onNavElementTap(BuildContext context, String element) {
    Navigator.pushNamed(context, element);
  }
}
