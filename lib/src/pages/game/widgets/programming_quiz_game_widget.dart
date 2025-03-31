import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/programming_quiz_game_provider.dart'; // Sửa import
import 'package:game_flutter/src/providers/audio_provider.dart';

class ProgrammingQuizGameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProgrammingQuizGameProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingQuestions) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final listData = provider.listNumber;
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade900, Colors.blue.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            child: Column(
              children: [
                _buildHeader(provider),
                30.verticalSpace,
                _buildQuestionCard(provider),
                30.verticalSpace,
                _buildOptionsGrid(context, listData, provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ProgrammingQuizGameProvider provider) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.star, size: 30.sp, color: Colors.yellow),
              10.horizontalSpace,
              Text(
                provider.core.toString(),
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.timer, size: 30.sp, color: Colors.white),
              10.horizontalSpace,
              StreamBuilder<int>(
                initialData: 0,
                stream: provider.timeStream,
                builder:
                    (context, snapshot) => Text(
                      snapshot.data.toString(),
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.hourglass_empty, size: 30.sp, color: Colors.white),
              10.horizontalSpace,
              StreamBuilder<int>(
                initialData: 10,
                stream: provider.questionTimeStream,
                builder:
                    (context, snapshot) => Text(
                      snapshot.data.toString(),
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.question_answer, size: 30.sp, color: Colors.white),
              10.horizontalSpace,
              Text(
                "${provider.currentQuestionIndex + 1}/${provider.maxQuestions}",
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(ProgrammingQuizGameProvider provider) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        provider.currentQuestion,
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptionsGrid(
    BuildContext context,
    List<int> listData,
    ProgrammingQuizGameProvider provider,
  ) {
    if (listData.isEmpty) {
      return Center(
        child: Text(
          "No options available",
          style: TextStyle(fontSize: 18.sp, color: Colors.white),
        ),
      );
    }

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20.w,
        mainAxisSpacing: 20.h,
        childAspectRatio: 2.5,
      ),
      itemCount: listData.length,
      itemBuilder: (context, index) {
        final question = provider.questionBank[provider.currentQuestionIndex];
        final optionsText = question["optionsText"] as List<String>?;
        return GestureDetector(
          onTap: () {
            Provider.of<AudioProvider>(
              context,
              listen: false,
            ).playButtonClickSound();
            Provider.of<ProgrammingQuizGameProvider>(
              context,
              listen: false,
            ).handleClick(index, context);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                optionsText != null
                    ? optionsText[index]
                    : listData[index].toString(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
