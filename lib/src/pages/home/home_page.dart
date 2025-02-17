import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_flutter/src/common/widget/button_custom.dart';
import 'package:game_flutter/src/pages/game/game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Home Page",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            123.verticalSpace,
            ButtonCustom(
              title: 'Start Game',
              onPressed: () {
                // Navigator.of(context).pushNamed(GamePage.routeName);
                Navigator.pushNamed(context, GamePage.routeName);
              },
            ),
            30.verticalSpace,
            ButtonCustom(title: 'Level'),
            30.verticalSpace,
            ButtonCustom(title: 'Score'),
            30.verticalSpace,
            ButtonCustom(title: 'Setting'),
          ],
        ),
      ),
    );
  }
}
