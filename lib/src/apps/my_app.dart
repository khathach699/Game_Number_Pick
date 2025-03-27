import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/pages/game/game_page.dart'; // Adjust import as needed
 // Adjust import as needed
import 'package:game_flutter/src/pages/home/home_page.dart'; // Adjust import as needed
import 'package:game_flutter/src/providers/history_provider.dart';

import '../pages/home/high_core_page.dart'; // Adjust import as needed

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
        // Add other providers here if needed (e.g., GameProvider)
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
            },
          );
        },
      ),
    );
  }
}