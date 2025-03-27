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
  void start(context) {
    runTimer(context);
  }

  void handleClick(int number, context) {
    initNumber++;
    if (number == initNumber) {
      dataNumber.add(number);
      core += 10;
    } else {
      ShowMessageError(context);
      timer!.cancel();
    }
    notifyListeners();
  }

  void runTimer(context) {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (count > 0) {
        count--;
        streamController.add(count);
      } else {
        ShowMessageError(context);
        timer?.cancel();
      }
    });
  }

  Future<dynamic> ShowMessageError(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Scaffold(
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
                          core.toString(),
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamController.close();
  }
}
