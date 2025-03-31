import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_flutter/src/common/widget/button_custom.dart';
import 'package:game_flutter/src/pages/game/game_page.dart';
import 'package:game_flutter/src/providers/level_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/audio_provider.dart';

class LevelPage extends StatelessWidget {
  static const routeName = '/level-page';
  const LevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Level',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: Consumer<LevelProvider>(
            builder: (context, levelProvider, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(7, (index) {
                  final level = index + 1;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: ButtonCustom(
                      title: 'Level $level',
                      onPressed: () {
                        Provider.of<AudioProvider>(context, listen: false).playButtonClickSound();
                        levelProvider.setLevel(level);
                        Navigator.pushNamed(context, GamePage.routeName);
                      },
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}