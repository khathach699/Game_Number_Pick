// lib/pages/game/game_page.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/game_provider.dart';
import 'package:game_flutter/src/providers/audio_provider.dart';
import '../../apps/my_app.dart';

class GamePage extends StatelessWidget with RouteAware {
  static const routeName = '/game-page';
  const GamePage({super.key});

  @override
  void didPush() {
    final audioProvider = Provider.of<AudioProvider>(MyApp.navigatorKey.currentContext!, listen: false);
    audioProvider.enterGamePage();
  }

  @override
  void didPop() {
    final audioProvider = Provider.of<AudioProvider>(MyApp.navigatorKey.currentContext!, listen: false);
    audioProvider.exitGamePage();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MyApp.routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
    });

    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    if (!gameProvider.isInitialized) gameProvider.start(context);

    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final listData = gameProvider.listNumber;
        return Scaffold(
          body: Container(
            width: 1.sw,
            height: 1.sh,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgrounds/image 1.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, size: 30.sp),
                          10.horizontalSpace,
                          Text(gameProvider.core.toString(), style: TextStyle(fontSize: 24.sp)),
                          Spacer(),
                          Icon(Icons.timer, size: 30.sp),
                          10.horizontalSpace,
                          StreamBuilder<int>(
                            initialData: gameProvider.count,
                            stream: gameProvider.streamController.stream,
                            builder: (context, snapshot) => Text(
                              snapshot.data.toString(),
                              style: TextStyle(fontSize: 24.sp),
                            ),
                          ),
                        ],
                      ),
                      if (gameProvider.gameMode == GameMode.colorMatch) ...[
                        20.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: gameProvider.targetColors
                              .map((color) => Container(
                            width: 30.w,
                            height: 30.h,
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            color: color,
                          ))
                              .toList(),
                        ),
                      ],
                      if (gameProvider.gameMode == GameMode.quickMath) ...[
                        20.verticalSpace,
                        Text(
                          gameProvider.mathQuestion,
                          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                      25.verticalSpace,
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: (sqrt(gameProvider.total)).toInt(),
                          crossAxisSpacing: 20.w,
                          mainAxisSpacing: 20.h,
                        ),
                        itemCount: listData.length,
                        itemBuilder: (context, index) {
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            child: Material(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                              clipBehavior: Clip.hardEdge,
                              child: InkWell(
                                splashColor: Colors.white.withOpacity(0.3),
                                onTap: () {
                                  Provider.of<AudioProvider>(context, listen: false)
                                      .playButtonClickSound();
                                  gameProvider.handleClick(listData[index], index, context);
                                },
                                child: Consumer<GameProvider>(
                                  builder: (_, data, __) {
                                    switch (data.gameMode) {
                                      case GameMode.sequence:
                                        return buildSequenceTile(data, listData[index]);
                                      case GameMode.matching:
                                        return buildMatchingTile(data, listData[index]);
                                      case GameMode.reflex:
                                        return buildReflexTile(data, index);
                                      case GameMode.countdown:
                                        return buildCountdownTile(data, listData[index]);
                                      case GameMode.colorMatch:
                                        return buildColorMatchTile(data, listData[index]);
                                      case GameMode.tileSwap:
                                        return buildTileSwapTile(data, listData[index], index);
                                      case GameMode.quickMath:
                                        return buildQuickMathTile(data, listData[index]);
                                      case GameMode.simonSays:
                                        return buildSimonSaysTile(data, index);
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildSequenceTile(GameProvider data, int number) {
    return Container(
      decoration: BoxDecoration(
        color: data.dataNumber.contains(number) ? Colors.white : Colors.blue,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Text(number.toString(), style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget buildMatchingTile(GameProvider data, int number) {
    return Container(
      decoration: BoxDecoration(
        color: data.matchedItems.contains(number)
            ? Colors.green
            : data.revealedItems.contains(number)
            ? Colors.blue
            : Colors.grey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Text(
          data.matchedItems.contains(number) || data.revealedItems.contains(number) ? number.toString() : "?",
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildReflexTile(GameProvider data, int index) {
    return Container(
      decoration: BoxDecoration(
        color: data.activeIndex == index ? Colors.yellow : Colors.grey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Text(
          data.activeIndex == index ? "Tap!" : "",
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildCountdownTile(GameProvider data, int number) {
    return Container(
      decoration: BoxDecoration(
        color: data.dataNumber.contains(number) ? Colors.white : Colors.red,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Text(number.toString(), style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget buildColorMatchTile(GameProvider data, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }

  Widget buildTileSwapTile(GameProvider data, int number, int index) {
    return Container(
      decoration: BoxDecoration(
        color: number == 0 ? Colors.transparent : Colors.orange,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.black, width: 1.w),
      ),
      child: Center(
        child: Text(
          number == 0 ? "" : number.toString(),
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildQuickMathTile(GameProvider data, int number) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Text(number.toString(), style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget buildSimonSaysTile(GameProvider data, int index) {
    return Container(
      decoration: BoxDecoration(
        color: data.simonStep == index ? Colors.yellow : Colors.grey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Text((index + 1).toString(), style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }
}