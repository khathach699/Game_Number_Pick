import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_flutter/src/common/widget/button_custom.dart';
import 'package:game_flutter/src/providers/history_provider.dart';
import 'package:game_flutter/src/providers/level_provider.dart';
import 'package:provider/provider.dart';

class GameProvider extends ChangeNotifier {
  late int total;
  late int count;
  late int initialTimeLimit;
  late List<int> listNumber;
  StreamController<int> streamController = StreamController<int>();
  late TextEditingController nameController;
  Timer? timer;
  int initNumber = 0;
  List<int> dataNumber = [];
  int core = 0;

  void start(BuildContext context) {
    final levelProvider = Provider.of<LevelProvider>(context, listen: false);
    total = levelProvider.totalNumbers;
    count = levelProvider.timeLimit;
    initialTimeLimit = levelProvider.timeLimit;

    nameController = TextEditingController();
    listNumber = List.generate(total, (index) => index + 1)..shuffle();
    runTimer(context);
  }

  void endGame(BuildContext context) {
    timer?.cancel();
    ShowMessageError(context);
  }

  void winGame(BuildContext context) {
    timer?.cancel();
    ShowMessageWin(context);
  }

  void handleClick(int number, BuildContext context) {
    initNumber++;
    if (number == initNumber) {
      dataNumber.add(number);
      core += 10;

      if (dataNumber.length == total) {
        winGame(context); // Gọi thông báo chiến thắng
      }
    } else {
      endGame(context); // Gọi thông báo thua nếu nhập sai
    }
    notifyListeners();
  }

  void runTimer(BuildContext context) {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (count > 0) {
        count--;
        streamController.add(count);
      } else {
        endGame(context);
        timer?.cancel();
      }
    });
  }

  void saveGame(BuildContext context) {
    if (nameController.text.isEmpty) return;

    final newScore = {
      "name": nameController.text,
      "score": core,
      "time": initialTimeLimit - count,
    };
    print("Saving score: $newScore");
    Provider.of<HistoryProvider>(context, listen: false).addScore(newScore);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<dynamic> ShowMessageError(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.dg),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 22.dg, horizontal: 58.dg),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  color: Colors.white,
                ),
                width: 365.dg,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Sorry, you failed",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Your score:",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        10.horizontalSpace,
                        Text(
                          core.toString(),
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    Row(
                      children: [
                        Text(
                          "Nhập Tên: ",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: nameController,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    ButtonCustom(
                      onPressed: () {
                        saveGame(context);
                      },
                      title: 'Save',
                      isEnable: true,
                      icon: "assets/icons/2.png",
                    ),
                    26.verticalSpace,
                    ButtonCustom(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      title: 'Try Again',
                      isEnable: true,
                      icon: "assets/icons/2.png",
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> ShowMessageWin(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.dg),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 22.dg, horizontal: 58.dg),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  color: Colors.white,
                ),
                width: 365.dg,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Congratulations, you won!",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Your score:",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        10.horizontalSpace,
                        Text(
                          core.toString(),
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    Row(
                      children: [
                        Text(
                          "Nhập Tên: ",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: nameController,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    ButtonCustom(
                      onPressed: () {
                        saveGame(context);
                      },
                      title: 'Save',
                      isEnable: true,
                      icon: "assets/icons/2.png",
                    ),
                    26.verticalSpace,
                    ButtonCustom(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      title: 'Play Again',
                      isEnable: true,
                      icon: "assets/icons/2.png",
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    streamController.close();
  }
}