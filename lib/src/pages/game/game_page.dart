import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_flutter/src/common/widget/button_custom.dart';
import 'package:game_flutter/src/providers/game_provider.dart';
import 'package:provider/provider.dart';

class GamePage extends StatelessWidget {
  static const routeName = '/game-page';
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final listDate = Provider.of<GameProvider>(context).listNumber;
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
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.dg),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset("assets/icons/Vector.png"),
                    10.horizontalSpace,
                    Text(
                      "10",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Image.asset("assets/icons/clock.png"),
                    10.horizontalSpace,
                    Text(
                      "10",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
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
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.dg,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 22.dg,
                                      horizontal: 58.dg,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40.r),
                                      color: Colors.white,
                                    ),
                                    width: 365.dg,
                                    height: 265.dg,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Sorry, your failed",
                                          style: TextStyle(
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        20.verticalSpace,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Your core:",
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
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Colors.primaries[index %
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
    );
  }
}
