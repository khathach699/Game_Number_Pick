import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_flutter/src/pages/game/game_page.dart';

import 'package:game_flutter/src/pages/home/home_page.dart';

import 'package:game_flutter/src/providers/game_provider.dart';
import 'package:game_flutter/src/providers/history_provider.dart';
import 'package:game_flutter/src/providers/level_provider.dart';
import 'package:provider/provider.dart';

import '../pages/game/level_page.dart';
import '../pages/home/high_core_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => LevelProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(414, 896),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Game Page',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 1.sp),
            ),
            home: const HomePage(),
            routes: {
              GamePage.routeName: (context) => const GamePage(),
              HighScorePage.routeName: (context) => const HighScorePage(),
              LevelPage.routeName: (context) => const LevelPage(),
            },
          );
        },
      ),
    );
  }
}