import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  List<int> listNumber = List.generate(50, (index) => index + 1)..shuffle();
}
