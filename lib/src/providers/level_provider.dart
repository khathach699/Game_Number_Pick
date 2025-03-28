import 'package:flutter/material.dart';

class LevelProvider extends ChangeNotifier {
  int _selectedLevel = 1;
  int _totalNumbers = 20;
  int _timeLimit = 60;

  int get selectedLevel => _selectedLevel;
  int get totalNumbers => _totalNumbers;
  int get timeLimit => _timeLimit;

  void setLevel(int level) {
    _selectedLevel = level;
    _setLevelDifficulty(level);
    notifyListeners();
  }

  void _setLevelDifficulty(int level) {
    switch (level) {
      case 1:
        _totalNumbers = 20;
        _timeLimit = 60;
        break;
      case 2:
        _totalNumbers = 30;
        _timeLimit = 60;
        break;
      case 3:
        _totalNumbers = 40;
        _timeLimit = 60;
        break;
      case 4:
        _totalNumbers = 50;
        _timeLimit = 70;
        break;
      case 5:
        _totalNumbers = 60;
        _timeLimit = 70;
        break;
      case 6:
        _totalNumbers = 80;
        _timeLimit = 70;
        break;
      case 7:
        _totalNumbers = 100;
        _timeLimit = 60;
        break;
    }
  }
}