// lib/providers/color_match_game_provider.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:game_flutter/src/common/widget/game_over_dialog.dart';
import 'package:game_flutter/src/common/widget/game_win_dialog.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/history_provider.dart';
import 'package:game_flutter/src/providers/level_provider.dart';

class ColorMatchGameProvider with ChangeNotifier {
  late int total;
  late int count;
  late int initialTimeLimit;
  late List<Color> listNumber;
  late StreamController<int> streamController;
  late TextEditingController nameController;
  Timer? timer;
  int core = 0;
  List<Color> targetColors = [];
  List<Color> playerColors = [];
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  Stream<int> get timeStream => streamController.stream;

  ColorMatchGameProvider() {
    streamController = StreamController<int>.broadcast();
    nameController = TextEditingController();
  }

  void start(BuildContext context) {
    if (_isInitialized) return;
    final levelProvider = Provider.of<LevelProvider>(context, listen: false);
    total = levelProvider.totalNumbers;
    count = levelProvider.timeLimit;
    initialTimeLimit = levelProvider.timeLimit;
    listNumber = List.generate(total, (_) => _randomColor())..shuffle();
    targetColors = List.generate(3, (_) => _randomColor());
    playerColors.clear();
    runTimer(context);
    _isInitialized = true;
    notifyListeners();
  }

  void reset(BuildContext? context) {
    _isInitialized = false;
    timer?.cancel();
    streamController.close();
    streamController = StreamController<int>.broadcast();
    core = 0;
    targetColors.clear();
    playerColors.clear();
    notifyListeners();
    if (context != null) start(context);
  }

  void runTimer(BuildContext context) {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (count > 0) {
        count--;
        streamController.add(count);
      } else {
        endGame(context);
      }
    });
  }

  void handleClick(Color item, BuildContext context) {
    playerColors.add(item);
    if (playerColors.length <= targetColors.length) {
      if (playerColors.last != targetColors[playerColors.length - 1]) {
        endGame(context);
      } else if (playerColors.length == targetColors.length) {
        core += 30;
        playerColors.clear();
        targetColors = List.generate(3, (_) => _randomColor());
        listNumber = List.generate(total, (_) => _randomColor())..shuffle();
      }
    }
    notifyListeners();
  }

  Color _randomColor() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
    ];
    return colors[Random().nextInt(colors.length)];
  }

  void endGame(BuildContext context) {
    timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => GameOverDialog(
            score: core,
            nameController: nameController,
            onSave: () => saveGame(context),
            onTryAgain: () {
              Navigator.pop(context);
              Navigator.pop(context);
              reset(context);
            },
          ),
    );
  }

  void winGame(BuildContext context) {
    timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => GameWinDialog(
            score: core,
            nameController: nameController,
            onSave: () => saveGame(context),
            onPlayAgain: () {
              Navigator.pop(context);
              Navigator.pop(context);
              reset(context);
            },
          ),
    );
  }

  void saveGame(BuildContext context) {
    if (nameController.text.isEmpty) return;
    final newScore = {
      "name": nameController.text,
      "score": core,
      "time": initialTimeLimit - count,
      "mode": "colorMatch",
    };
    Provider.of<HistoryProvider>(context, listen: false).addScore(newScore);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    streamController.close();
    nameController.dispose();
    timer?.cancel();
    super.dispose();
  }
}
