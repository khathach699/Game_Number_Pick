import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:game_flutter/src/common/widget/game_over_dialog.dart';
import 'package:game_flutter/src/common/widget/game_win_dialog.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/history_provider.dart';
import 'package:game_flutter/src/providers/level_provider.dart';

class QuickMathGameProvider with ChangeNotifier {
  late int total;
  late int count;
  late int initialTimeLimit;
  late List<int> listNumber;
  late List<Color> tileColors; // Danh sách màu cho các ô
  late StreamController<int> streamController;
  late TextEditingController nameController;
  Timer? timer;
  int core = 0;
  String mathQuestion = "";
  int correctAnswer = 0;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  Stream<int> get timeStream => streamController.stream;

  QuickMathGameProvider() {
    streamController = StreamController<int>.broadcast();
    nameController = TextEditingController();
  }

  void start(BuildContext context) {
    if (_isInitialized) return;
    final levelProvider = Provider.of<LevelProvider>(context, listen: false);
    total = levelProvider.totalNumbers;
    count = levelProvider.timeLimit;
    initialTimeLimit = levelProvider.timeLimit;
    _generateMathQuestion();
    listNumber = _generateMathOptions();
    tileColors = List.generate(
      total,
      (_) => _randomColor(),
    ); // Tạo màu ngẫu nhiên
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
    mathQuestion = "";
    tileColors.clear();
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

  void handleClick(int item, BuildContext context) {
    if (item == correctAnswer) {
      core += 20;
      _generateMathQuestion();
      listNumber = _generateMathOptions();
      tileColors = List.generate(
        total,
        (_) => _randomColor(),
      ); // Cập nhật màu mới
    } else {
      endGame(context);
    }
    notifyListeners();
  }

  void _generateMathQuestion() {
    int a = Random().nextInt(20) + 1; // +1 để tránh chia cho 0
    int b = Random().nextInt(20) + 1;
    int op =
        _weightedRandomOperation(); // Sử dụng hàm chọn phép toán có trọng số
    switch (op) {
      case 0: // Cộng
        mathQuestion = "$a + $b = ?";
        correctAnswer = a + b;
        break;
      case 1: // Trừ
        mathQuestion = "$a - $b = ?";
        correctAnswer = a - b;
        break;
      case 2: // Nhân
        mathQuestion = "$a * $b = ?";
        correctAnswer = a * b;
        break;
      case 3: // Chia
        mathQuestion = "${a * b} / $b = ?"; // Đảm bảo kết quả là số nguyên
        correctAnswer = (a * b) ~/ b;
        break;
    }
  }

  int _weightedRandomOperation() {
    // Tăng xác suất phép nhân (40%), phép chia (20%), cộng và trừ (mỗi cái 20%)
    int random = Random().nextInt(100);
    if (random < 20) return 0; // Cộng: 20%
    if (random < 40) return 1; // Trừ: 20%
    if (random < 80) return 2; // Nhân: 40%
    return 3; // Chia: 20%
  }

  List<int> _generateMathOptions() {
    List<int> options = [correctAnswer];
    int attempts = 0;
    while (options.length < total && attempts < 100) {
      int wrong = correctAnswer + Random().nextInt(20) - 10;
      if (!options.contains(wrong)) {
        options.add(wrong);
      }
      attempts++;
    }
    while (options.length < total) {
      int filler = Random().nextInt(100);
      if (!options.contains(filler)) options.add(filler);
    }
    return options..shuffle();
  }

  Color _randomColor() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.cyan,
      Colors.grey,
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
      "mode": "quickMath",
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
