// lib/providers/tile_swap_game_provider.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:game_flutter/src/common/widget/game_over_dialog.dart';
import 'package:game_flutter/src/common/widget/game_win_dialog.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/history_provider.dart';
import 'package:game_flutter/src/providers/level_provider.dart';

class TileSwapGameProvider with ChangeNotifier {
  late int total;
  late int count;
  late int initialTimeLimit;
  late List<int> listNumber;
  late StreamController<int> streamController;
  late TextEditingController nameController;
  Timer? timer;
  int core = 0;
  int? emptyIndex;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  Stream<int> get timeStream => streamController.stream;

  TileSwapGameProvider() {
    streamController = StreamController<int>.broadcast();
    nameController = TextEditingController();
  }

  void start(BuildContext context) {
    if (_isInitialized) return;
    final levelProvider = Provider.of<LevelProvider>(context, listen: false);
    total = levelProvider.totalNumbers;
    count = levelProvider.timeLimit;
    initialTimeLimit = levelProvider.timeLimit;
    listNumber = List.generate(total - 1, (index) => index + 1)..shuffle();
    listNumber.add(0); // Ô trống
    emptyIndex = total - 1;
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
    emptyIndex = null;
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

  void handleClick(int item, int index, BuildContext context) {
    if (_canSwap(index, emptyIndex!)) {
      listNumber[emptyIndex!] = item;
      listNumber[index] = 0;
      emptyIndex = index;
      core += 5;
      if (_isTileSolved()) winGame(context);
    }
    notifyListeners();
  }

  bool _canSwap(int index, int empty) {
    int rowSize = (sqrt(total)).toInt();
    int indexRow = index ~/ rowSize;
    int emptyRow = empty ~/ rowSize;
    int indexCol = index % rowSize;
    int emptyCol = empty % rowSize;
    return (indexRow == emptyRow && (indexCol - emptyCol).abs() == 1) ||
        (indexCol == emptyCol && (indexRow - emptyRow).abs() == 1);
  }

  bool _isTileSolved() {
    for (int i = 0; i < total - 1; i++) {
      if (listNumber[i] != i + 1) return false;
    }
    return listNumber.last == 0;
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
      "mode": "tileSwap",
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
