import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:game_flutter/src/providers/game_provider.dart';
import 'package:provider/provider.dart';
import '../../apps/my_app.dart';
import '../../providers/audio_provider.dart';

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
  void didPushNext() {
    final audioProvider = Provider.of<AudioProvider>(MyApp.navigatorKey.currentContext!, listen: false);
    audioProvider.exitGamePage();
  }

  @override
  void didPopNext() {
    final audioProvider = Provider.of<AudioProvider>(MyApp.navigatorKey.currentContext!, listen: false);
    audioProvider.enterGamePage();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MyApp.routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
    });

    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    if (!gameProvider.isInitialized) {
      gameProvider.start(context);
    }

    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final listDate = gameProvider.listNumber;
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
                  padding: EdgeInsets.symmetric(horizontal: 25.dg),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/icons/Vector.png"),
                          10.horizontalSpace,
                          Consumer<GameProvider>(
                            builder: (_, data, __) {
                              return Text(
                                data.core.toString(),
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          const Spacer(),
                          Image.asset("assets/icons/clock.png"),
                          10.horizontalSpace,
                          StreamBuilder<int>(
                            initialData: gameProvider.count,
                            stream: gameProvider.streamController.stream,
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.hasData ? snapshot.data.toString() : "0",
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          10.horizontalSpace,
                          Consumer<AudioProvider>(
                            builder: (context, audioProvider, child) {
                              return IconButton(
                                icon: Icon(
                                  audioProvider.isMusicEnabled
                                      ? Icons.music_note
                                      : Icons.music_off,
                                  color: Colors.white,
                                  size: 30.sp,
                                ),
                                onPressed: () {
                                  audioProvider.toggleMusic(!audioProvider.isMusicEnabled);
                                },
                              );
                            },
                          ),
                          10.horizontalSpace,
                          Consumer<AudioProvider>(
                            builder: (context, audioProvider, child) {
                              return IconButton(
                                icon: Icon(
                                  audioProvider.isSoundEnabled
                                      ? Icons.volume_up
                                      : Icons.volume_off,
                                  color: Colors.white,
                                  size: 30.sp,
                                ),
                                onPressed: () {
                                  audioProvider.toggleSound(!audioProvider.isSoundEnabled);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      25.verticalSpace,
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 20.w,
                          mainAxisSpacing: 20.h,
                        ),
                        itemCount: listDate.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Material(
                            shape: CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              splashColor: Colors.white,
                              onTap: () {
                                Provider.of<AudioProvider>(context, listen: false).playButtonClickSound();
                                context.read<GameProvider>().handleClick(listDate[index], context);
                              },
                              child: Consumer<GameProvider>(
                                builder: (_, data, __) {
                                  return Ink(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: data.dataNumber.contains(listDate[index])
                                          ? Colors.white
                                          : Colors.primaries[index % Colors.primaries.length],
                                    ),
                                    child: Center(
                                      child: Text(
                                        listDate[index].toString(),
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
}