// lib/pages/home/game_mode_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/game_provider.dart';
import '../game/game_page.dart';

class GameModePage extends StatelessWidget {
  static const routeName = '/game-mode-page';
  const GameModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Game Mode", style: TextStyle(fontSize: 22.sp))),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildModeButton(context, "Sequence", GameMode.sequence),
              20.verticalSpace,
              buildModeButton(context, "Matching", GameMode.matching),
              20.verticalSpace,
              buildModeButton(context, "Reflex", GameMode.reflex),
              20.verticalSpace,
              buildModeButton(context, "Countdown", GameMode.countdown),
              20.verticalSpace,
              buildModeButton(context, "Color Match", GameMode.colorMatch),
              20.verticalSpace,
              buildModeButton(context, "Tile Swap", GameMode.tileSwap),
              20.verticalSpace,
              buildModeButton(context, "Quick Math", GameMode.quickMath),
              20.verticalSpace,
              buildModeButton(context, "Simon Says", GameMode.simonSays),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildModeButton(BuildContext context, String title, GameMode mode) {
    return ElevatedButton(
      onPressed: () {
        Provider.of<GameProvider>(context, listen: false).setGameMode(mode);
        Navigator.pushNamed(context, GamePage.routeName);
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
      child: Text(title, style: TextStyle(fontSize: 20.sp)),
    );
  }
}