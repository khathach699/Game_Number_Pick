import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/pages/home/wrapper_page.dart';
import 'package:game_flutter/src/pages/game/game_page.dart';
import 'package:game_flutter/src/pages/home/game_mode_page.dart';
import 'package:game_flutter/src/pages/home/setting_page.dart';
import 'package:game_flutter/src/pages/game/level_page.dart';
import 'package:game_flutter/src/pages/home/high_core_page.dart';
import 'package:game_flutter/src/providers/game_provider.dart';
import 'package:game_flutter/src/providers/history_provider.dart';
import 'package:game_flutter/src/providers/level_provider.dart';
import 'package:game_flutter/src/providers/audio_provider.dart';
import 'package:game_flutter/src/providers/auth_provider.dart'; // Thêm AuthProvider

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => LevelProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()), // Thêm AuthProvider
      ],
      child: ScreenUtilInit(
        designSize: const Size(414, 896),
        minTextAdapt: true,
        builder: (_, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Game Hub',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: const WrapperPage(),
            routes: {
              GamePage.routeName: (context) => const GamePage(),
              GameModePage.routeName: (context) => const GameModePage(),
              HighScorePage.routeName: (context) => const HighScorePage(),
              LevelPage.routeName: (context) => const LevelPage(),
              SettingPage.routeName: (context) => const SettingPage(),
            },
            navigatorObservers: [routeObserver],
          );
        },
      ),
    );
  }
}