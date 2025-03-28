// lib/providers/game_provider.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/history_provider.dart';
import 'package:game_flutter/src/providers/level_provider.dart';
import 'package:game_flutter/src/providers/audio_provider.dart';

enum GameMode { sequence, matching, reflex, countdown, colorMatch, tileSwap, quickMath, simonSays }

class GameProvider extends ChangeNotifier {
  late int total;
  late int count;
  late int initialTimeLimit;
  late List<dynamic> listNumber; // Sử dụng dynamic để linh hoạt với các loại dữ liệu
  late StreamController<int> streamController;
  late TextEditingController nameController;
  Timer? timer;
  int core = 0;
  bool _isInitialized = false;
  GameMode gameMode = GameMode.sequence;

  // Sequence & Countdown
  int initNumber = 0;
  List<int> dataNumber = [];

  // Matching
  List<int> revealedItems = [];
  List<int> matchedItems = [];

  // Reflex
  int? activeIndex;

  // Color Match
  List<Color> targetColors = [];
  List<Color> playerColors = [];

  // Tile Swap
  int? emptyIndex;

  // Quick Math
  String mathQuestion = "";
  int correctAnswer = 0;

  // Simon Says
  List<int> simonSequence = [];
  List<int> playerSequence = [];
  int simonStep = -1;

  bool get isInitialized => _isInitialized;

  GameProvider() {
    streamController = StreamController<int>.broadcast();
  }

  void setGameMode(GameMode mode) {
    gameMode = mode;
    reset(null);
  }

  void start(BuildContext context) {
    if (_isInitialized) return;
    final levelProvider = Provider.of<LevelProvider>(context, listen: false);
    total = levelProvider.totalNumbers;
    count = levelProvider.timeLimit;
    initialTimeLimit = levelProvider.timeLimit;
    nameController = TextEditingController();

    switch (gameMode) {
      case GameMode.sequence:
        listNumber = List.generate(total, (index) => index + 1)..shuffle();
        initNumber = 0;
        break;
      case GameMode.matching:
        listNumber = List.generate(total ~/ 2, (index) => index + 1)
            .expand((i) => [i, i])
            .toList()
          ..shuffle();
        break;
      case GameMode.reflex:
        listNumber = List.filled(total, 0);
        activateRandomTile();
        break;
      case GameMode.countdown:
        listNumber = List.generate(total, (index) => index + 1)..shuffle();
        initNumber = total;
        break;
      case GameMode.colorMatch:
        listNumber = List.generate(total, (_) => _randomColor())..shuffle();
        targetColors = List.generate(3, (_) => _randomColor());
        playerColors.clear();
        break;
      case GameMode.tileSwap:
        listNumber = List.generate(total - 1, (index) => index + 1)..shuffle();
        listNumber.add(0); // Ô trống
        emptyIndex = total - 1;
        break;
      case GameMode.quickMath:
        _generateMathQuestion();
        listNumber = _generateMathOptions();
        break;
      case GameMode.simonSays:
        listNumber = List.generate(total, (index) => index);
        simonSequence.clear();
        playerSequence.clear();
        simonStep = -1;
        addSimonStep();
        break;
    }
    runTimer(context);
    _isInitialized = true;
  }

  void reset(BuildContext? context) {
    _isInitialized = false;
    timer?.cancel();
    streamController.close();
    streamController = StreamController<int>.broadcast();
    core = 0;
    initNumber = 0;
    dataNumber.clear();
    revealedItems.clear();
    matchedItems.clear();
    activeIndex = null;
    targetColors.clear();
    playerColors.clear();
    emptyIndex = null;
    mathQuestion = "";
    simonSequence.clear();
    playerSequence.clear();
    simonStep = -1;
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

  void handleClick(dynamic item, int index, BuildContext context) {
    switch (gameMode) {
      case GameMode.sequence:
        initNumber++;
        if (item == initNumber) {
          dataNumber.add(item);
          core += 10;
          if (dataNumber.length == total) winGame(context);
        } else {
          endGame(context);
        }
        break;
      case GameMode.matching:
        if (revealedItems.length < 2 && !matchedItems.contains(item)) {
          revealedItems.add(item);
          if (revealedItems.length == 2) {
            if (revealedItems[0] == revealedItems[1]) {
              matchedItems.addAll(revealedItems);
              core += 20;
              if (matchedItems.length == total) winGame(context);
            }
            Future.delayed(Duration(seconds: 1), () {
              revealedItems.clear();
              notifyListeners();
            });
          }
        }
        break;
      case GameMode.reflex:
        if (index == activeIndex) {
          core += 15;
          activateRandomTile();
        } else {
          endGame(context);
        }
        break;
      case GameMode.countdown:
        if (item == initNumber) {
          dataNumber.add(item);
          core += 10;
          initNumber--;
          if (dataNumber.length == total) winGame(context);
        } else {
          endGame(context);
        }
        break;
      case GameMode.colorMatch:
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
        break;
      case GameMode.tileSwap:
        if (_canSwap(index, emptyIndex!)) {
          listNumber[emptyIndex!] = item;
          listNumber[index] = 0;
          emptyIndex = index;
          core += 5;
          if (_isTileSolved()) winGame(context);
        }
        break;
      case GameMode.quickMath:
        if (item == correctAnswer) {
          core += 20;
          _generateMathQuestion();
          listNumber = _generateMathOptions();
        } else {
          endGame(context);
        }
        break;
      case GameMode.simonSays:
        playerSequence.add(index);
        if (playerSequence.length <= simonSequence.length) {
          if (playerSequence.last != simonSequence[playerSequence.length - 1]) {
            endGame(context);
          } else if (playerSequence.length == simonSequence.length) {
            core += 20;
            playerSequence.clear();
            simonStep = -1;
            addSimonStep();
            if (simonSequence.length >= total) winGame(context);
          }
        }
        break;
    }
    notifyListeners();
  }

  void activateRandomTile() {
    activeIndex = Random().nextInt(total);
    notifyListeners();
    Future.delayed(Duration(seconds: 2), () {
      if (activeIndex != null) {
        activeIndex = null;
        notifyListeners();
      }
    });
  }

  Color _randomColor() {
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple];
    return colors[Random().nextInt(colors.length)];
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

  void _generateMathQuestion() {
    int a = Random().nextInt(20);
    int b = Random().nextInt(20);
    int op = Random().nextInt(3);
    switch (op) {
      case 0:
        mathQuestion = "$a + $b = ?";
        correctAnswer = a + b;
        break;
      case 1:
        mathQuestion = "$a - $b = ?";
        correctAnswer = a - b;
        break;
      case 2:
        mathQuestion = "$a * $b = ?";
        correctAnswer = a * b;
        break;
    }
  }

  List<int> _generateMathOptions() {
    List<int> options = [correctAnswer];
    while (options.length < total) {
      int wrong = correctAnswer + Random().nextInt(10) - 5;
      if (!options.contains(wrong) && wrong != correctAnswer) options.add(wrong);
    }
    return options..shuffle();
  }

  void addSimonStep() {
    simonSequence.add(Random().nextInt(total));
    playSimonSequence();
  }

  void playSimonSequence() async {
    for (int i = 0; i < simonSequence.length; i++) {
      simonStep = simonSequence[i];
      notifyListeners();
      await Future.delayed(Duration(milliseconds: 500));
      simonStep = -1;
      notifyListeners();
      await Future.delayed(Duration(milliseconds: 200));
    }
  }

  void endGame(BuildContext context) {
    timer?.cancel();
    showMessageError(context);
  }

  void winGame(BuildContext context) {
    timer?.cancel();
    showMessageWin(context);
  }

  void saveGame(BuildContext context) {
    if (nameController.text.isEmpty) return;
    final newScore = {
      "name": nameController.text,
      "score": core,
      "time": initialTimeLimit - count,
      "mode": gameMode.toString().split('.').last,
    };
    Provider.of<HistoryProvider>(context, listen: false).addScore(newScore);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<void> showMessageError(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => FadeTransition(
        opacity: CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeIn,
        ),
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          child: Container(
            width: 365.w,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10.r)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 50.sp, color: Colors.red),
                SizedBox(height: 15.h),
                Text(
                  "Sorry, You Failed!",
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Your Score: ", style: TextStyle(fontSize: 20.sp)),
                    Text(
                      core.toString(),
                      style: TextStyle(fontSize: 20.sp, color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text("Name: ", style: TextStyle(fontSize: 20.sp)),
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        style: TextStyle(fontSize: 18.sp),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<AudioProvider>(context, listen: false).playButtonClickSound();
                        saveGame(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: Text("Save", style: TextStyle(fontSize: 18.sp)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<AudioProvider>(context, listen: false).playButtonClickSound();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        reset(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: Text("Try Again", style: TextStyle(fontSize: 18.sp)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showMessageWin(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => FadeTransition(
        opacity: CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeIn,
        ),
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          child: Container(
            width: 365.w,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10.r)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 50.sp, color: Colors.yellow[700]),
                SizedBox(height: 15.h),
                Text(
                  "Congratulations, You Won!",
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Your Score: ", style: TextStyle(fontSize: 20.sp)),
                    Text(
                      core.toString(),
                      style: TextStyle(fontSize: 20.sp, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text("Name: ", style: TextStyle(fontSize: 20.sp)),
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        style: TextStyle(fontSize: 18.sp),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<AudioProvider>(context, listen: false).playButtonClickSound();
                        saveGame(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: Text("Save", style: TextStyle(fontSize: 18.sp)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<AudioProvider>(context, listen: false).playButtonClickSound();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        reset(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: Text("Play Again", style: TextStyle(fontSize: 18.sp)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }
}