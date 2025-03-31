// lib/widgets/game_over_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/audio_provider.dart';

class GameOverDialog extends StatelessWidget {
  final int score;
  final TextEditingController nameController;
  final VoidCallback onSave;
  final VoidCallback onTryAgain;

  const GameOverDialog({
    Key? key,
    required this.score,
    required this.nameController,
    required this.onSave,
    required this.onTryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: ModalRoute.of(context)!.animation!,
        curve: Curves.easeIn,
      ),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          width: 365.w,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10.r)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 50.sp, color: Colors.red),
              SizedBox(height: 15.h),
              Text(
                "Sorry, You Failed!",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Your Score: ", style: TextStyle(fontSize: 20.sp)),
                  Text(
                    score.toString(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Text("Name: ", style: TextStyle(fontSize: 20.sp)),
                  Expanded(
                    child: TextFormField(
                      controller: nameController,
                      style: TextStyle(fontSize: 18.sp),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<AudioProvider>(
                        context,
                        listen: false,
                      ).playButtonClickSound();
                      onSave();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text("Save", style: TextStyle(fontSize: 18.sp)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<AudioProvider>(
                        context,
                        listen: false,
                      ).playButtonClickSound();
                      onTryAgain();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text("Try Again", style: TextStyle(fontSize: 18.sp)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
