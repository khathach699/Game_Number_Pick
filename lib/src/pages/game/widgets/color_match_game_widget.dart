// lib/pages/game/widgets/color_match_game_widget.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/game_provider.dart';
import 'package:game_flutter/src/providers/color_match_game_provider.dart';
import 'package:game_flutter/src/providers/audio_provider.dart';

class ColorMatchGameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ColorMatchGameProvider>(
      builder: (context, provider, child) {
        final listData = provider.listNumber;
        return Column(
          children: [
            _buildHeader(provider.timeStream, provider.core),
            20.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  provider.targetColors
                      .map(
                        (color) => Container(
                          width: 30.w,
                          height: 30.h,
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          color: color,
                        ),
                      )
                      .toList(),
            ),
            25.verticalSpace,
            _buildGrid(context, listData, provider),
          ],
        );
      },
    );
  }

  Widget _buildHeader(Stream<int> timeStream, int score) {
    return Row(
      children: [
        Icon(Icons.star, size: 30.sp),
        10.horizontalSpace,
        Text(score.toString(), style: TextStyle(fontSize: 24.sp)),
        Spacer(),
        Icon(Icons.timer, size: 30.sp),
        10.horizontalSpace,
        StreamBuilder<int>(
          initialData: 0,
          stream: timeStream,
          builder:
              (context, snapshot) => Text(
                snapshot.data.toString(),
                style: TextStyle(fontSize: 24.sp),
              ),
        ),
      ],
    );
  }

  Widget _buildGrid(
    BuildContext context,
    List<Color> listData,
    ColorMatchGameProvider provider,
  ) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (sqrt(provider.total)).toInt(),
        crossAxisSpacing: 20.w,
        mainAxisSpacing: 20.h,
      ),
      itemCount: listData.length,
      itemBuilder: (context, index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.white.withOpacity(0.3),
              onTap: () {
                Provider.of<AudioProvider>(
                  context,
                  listen: false,
                ).playButtonClickSound();
                Provider.of<GameProvider>(
                  context,
                  listen: false,
                ).handleClick(listData[index], index, context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: listData[index],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
