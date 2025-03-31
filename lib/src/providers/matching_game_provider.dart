// lib/providers/matching_game_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:game_flutter/src/common/widget/game_over_dialog.dart';
import 'package:game_flutter/src/common/widget/game_win_dialog.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/history_provider.dart';
import 'package:game_flutter/src/providers/level_provider.dart';

class MatchingGameProvider with ChangeNotifier {
  late int total;
  late int count;
  late int initialTimeLimit;
  late List<int> listNumber;
  late StreamController<int> streamController;
  late TextEditingController nameController;
  Timer? timer;
  int core = 0;
  List<int> revealedIndices = []; // Lưu index của các ô được lật
  List<int> matchedIndices = []; // Lưu index của các ô đã ghép
  bool _isInitialized = false;
  bool isProcessing = false;

  bool get isInitialized => _isInitialized;
  Stream<int> get timeStream => streamController.stream;

  MatchingGameProvider() {
    streamController = StreamController<int>.broadcast();
    nameController = TextEditingController();
  }

  void start(BuildContext context) {
    if (_isInitialized) return;
    final levelProvider = Provider.of<LevelProvider>(context, listen: false);
    total = levelProvider.totalNumbers;
    count = levelProvider.timeLimit;
    initialTimeLimit = levelProvider.timeLimit;
    listNumber =
        List.generate(
            total ~/ 2,
            (index) => index + 1,
          ).expand((i) => [i, i]).toList()
          ..shuffle();
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
    revealedIndices.clear();
    matchedIndices.clear();
    isProcessing = false; // Reset isProcessing
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
    if (isProcessing ||
        revealedIndices.length >= 2 ||
        matchedIndices.contains(index)) {
      return; // Ngăn xử lý khi đang bận hoặc ô đã ghép
    }

    revealedIndices.add(index);
    notifyListeners(); // Cập nhật giao diện ngay khi lật ô

    if (revealedIndices.length == 2) {
      isProcessing = true; // Khóa xử lý khi đã lật 2 ô
      if (listNumber[revealedIndices[0]] == listNumber[revealedIndices[1]] &&
          revealedIndices[0] != revealedIndices[1]) {
        // Kiểm tra index khác nhau
        matchedIndices.addAll(revealedIndices);
        core += 20;
        if (matchedIndices.length == total) winGame(context);
      }
      Future.delayed(Duration(seconds: 1), () {
        revealedIndices.clear();
        isProcessing = false; // Mở khóa sau khi hoàn tất
        notifyListeners();
      });
    }
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
      "mode": "matching",
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
