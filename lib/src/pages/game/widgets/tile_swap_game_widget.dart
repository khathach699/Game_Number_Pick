// lib/pages/game/widgets/tile_swap_game_widget.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/game_provider.dart';
import 'package:game_flutter/src/providers/tile_swap_game_provider.dart';
import 'package:game_flutter/src/providers/audio_provider.dart';

class TileSwapGameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TileSwapGameProvider>(
      builder: (context, provider, child) {
        final listData = provider.listNumber;
        return Column(
          children: [
            _buildHeader(provider.timeStream, provider.core),
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
    List<int> listData,
    TileSwapGameProvider provider,
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
                  color:
                      listData[index] == 0 ? Colors.transparent : Colors.orange,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.black, width: 1.w),
                ),
                child: Center(
                  child: Text(
                    listData[index] == 0 ? "" : listData[index].toString(),
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
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
