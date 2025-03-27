import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _scores = [];

  List<Map<String, dynamic>> get scores => _scores;

  HistoryProvider() {
    _loadScores();
  }

  Future<void> _loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    final String? scoresString = prefs.getString('scores');
    if (scoresString != null) {
      _scores = List<Map<String, dynamic>>.from(json.decode(scoresString));
      _scores.sort((a, b) => b['score'].compareTo(a['score']));
      notifyListeners();
    }
  }

  Future<void> addScore(Map<String, dynamic> score) async {
    _scores.add(score);
    _scores.sort((a, b) => b['score'].compareTo(a['score']));
    notifyListeners();
    await _saveScores();
  }

  Future<void> _saveScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('scores', json.encode(_scores));
  }
}