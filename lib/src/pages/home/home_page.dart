// lib/pages/home/home_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/audio_provider.dart';
import 'game_mode_page.dart';

import 'high_core_page.dart';
import 'setting_page.dart';
import '../game/level_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Username: ${user!.email}"),
            50.verticalSpace,
            Text("Game Hub", style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold)),
            50.verticalSpace,
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, GameModePage.routeName),
              child: Text("Start Game", style: TextStyle(fontSize: 20.sp)),
            ),
            20.verticalSpace,
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, LevelPage.routeName),
              child: Text("Levels", style: TextStyle(fontSize: 20.sp)),
            ),
            20.verticalSpace,
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, HighScorePage.routeName),
              child: Text("High Scores", style: TextStyle(fontSize: 20.sp)),
            ),
            20.verticalSpace,
            ElevatedButton(
              onPressed: () {
                Provider.of<AudioProvider>(context, listen: false).playButtonClickSound();
                Navigator.pushNamed(context, SettingPage.routeName);
              },
              child: Text("Settings", style: TextStyle(fontSize: 20.sp)),
            ),
          ],
        ),
      ),
    );
  }
}