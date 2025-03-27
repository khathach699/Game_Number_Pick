import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_flutter/src/pages/game/game_page.dart';
import 'package:game_flutter/src/pages/home/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
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
          }, // Set HomePage here
        );
      },
    );
  }
}
