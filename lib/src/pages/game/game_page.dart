import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_flutter/src/providers/game_provider.dart';
import 'package:provider/provider.dart';

class GamePage extends StatelessWidget {
  static const routeName = '/game-page';
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider()..start(context),
      child: Consumer<GameProvider>(
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
                              initialData:
                                  context
                                      .read<GameProvider>()
                                      .count, // Set initial value
                              stream:
                                  context
                                      .read<GameProvider>()
                                      .streamController
                                      .stream, // Stream to listen to
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.hasData
                                      ? snapshot.data.toString()
                                      : "0",
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                onTap:
                                    () => context
                                        .read<GameProvider>()
                                        .handleClick(listDate[index], context),
                                child: Consumer<GameProvider>(
                                  builder: (_, data, __) {
                                    return Ink(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            data.dataNumber.contains(
                                                  listDate[index],
                                                )
                                                ? Colors.white
                                                : Colors.primaries[index %
                                                    Colors.primaries.length],
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
      ),
    );
  }
}
