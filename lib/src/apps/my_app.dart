import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_flutter/src/pages/auth/login_page.dart';
import 'package:game_flutter/src/pages/auth/signup_page.dart';
import 'package:game_flutter/src/providers/color_match_game_provider.dart';
import 'package:game_flutter/src/providers/countdown_game_provider.dart';
import 'package:game_flutter/src/providers/matching_game_provider.dart';
import 'package:game_flutter/src/providers/quick_math_game_provider.dart';
import 'package:game_flutter/src/providers/reflex_game_provider.dart';
import 'package:game_flutter/src/providers/sequence_game_provider.dart';
import 'package:game_flutter/src/providers/simon_says_game_provider.dart';
import 'package:game_flutter/src/providers/tile_swap_game_provider.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/pages/home/wrapper_page.dart';
import 'package:game_flutter/src/pages/game/game_page.dart';
import 'package:game_flutter/src/pages/home/game_mode_page.dart';
import 'package:game_flutter/src/pages/home/setting_page.dart';
import 'package:game_flutter/src/pages/home/level_page.dart';
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

  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => LevelProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => SequenceGameProvider()),
        ChangeNotifierProvider(create: (_) => MatchingGameProvider()),
        ChangeNotifierProvider(create: (_) => ReflexGameProvider()),
        ChangeNotifierProvider(create: (_) => CountdownGameProvider()),
        ChangeNotifierProvider(create: (_) => ColorMatchGameProvider()),
        ChangeNotifierProvider(create: (_) => TileSwapGameProvider()),
        ChangeNotifierProvider(create: (_) => QuickMathGameProvider()),
        ChangeNotifierProvider(create: (_) => SimonSaysGameProvider()),
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
              SignupPage.routeName: (context) => const SignupPage(),
              LoginPage.routeName: (context) => const LoginPage(),
            },
            navigatorObservers: [routeObserver],
          );
        },
      ),
    );
  }
}
