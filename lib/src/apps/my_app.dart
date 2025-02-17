import 'package:flutter/material.dart';
import 'package:game_flutter/src/pages/game/game_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: GamePage());
  }
}
