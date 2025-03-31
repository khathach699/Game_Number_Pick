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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple.shade700, Colors.blue.shade400],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Select Game Mode',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        20.verticalSpace,
                        buildModeButton(context, "Sequence", GameMode.sequence),
                        20.verticalSpace,
                        buildModeButton(context, "Matching", GameMode.matching),
                        20.verticalSpace,
                        buildModeButton(context, "Reflex", GameMode.reflex),
                        20.verticalSpace,
                        buildModeButton(
                          context,
                          "Countdown",
                          GameMode.countdown,
                        ),
                        20.verticalSpace,
                        // buildModeButton(
                        //   context,
                        //   "Color Match",
                        //   GameMode.colorMatch,
                        // ),
                        // 20.verticalSpace,
                        // buildModeButton(
                        //   context,
                        //   "Tile Swap",
                        //   GameMode.tileSwap,
                        // ),
                        // 20.verticalSpace,
                        buildModeButton(
                          context,
                          "Quick Math",
                          GameMode.quickMath,
                        ),
                        20.verticalSpace,
                        // buildModeButton(
                        //   context,
                        //   "Programming Quiz",
                        //   GameMode.simonSays,
                        // ),
                        // 20.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple.shade700,
        minimumSize: Size(220.w, 60.h),
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        elevation: 8,
        shadowColor: Colors.black45,
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
