import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_flutter/src/common/widget/button_custom.dart';

class GameProvider extends ChangeNotifier {
  List<int> listNumber = List.generate(50, (index) => index + 1)..shuffle();
  StreamController<int> streamController = StreamController<int>();
  Timer? timer;
  int count = 60;
  int initNumber = 0;
  List<int> dataNumber = [];
  int core = 0;
  void start() {
    runTimer();
  }

  void handleClick(int number) {
    initNumber++;
    if (number == initNumber) {
      dataNumber.add(number);
      core += 10;
    } else {
      print("Loser");
    }
    notifyListeners();
  }

  void runTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (count > 0) {
        count--;
        streamController.add(count);
      } else {
        timer?.cancel();
      }
    });
  }

  Future<dynamic> ShowMessageError(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.dg),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 22.dg, horizontal: 58.dg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.r),
                color: Colors.white,
              ),
              width: 365.dg,
              height: 265.dg,
              child: Column(
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
                        "20",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  55.verticalSpace,
                  ButtonCustom(
                    title: 'Try Again',
                    isEnable: true,
                    icon: "assets/icons/2.png",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamController.close();
  }
}
