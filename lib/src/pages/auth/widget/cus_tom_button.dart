import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const CustomButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade900,
        minimumSize: Size(double.infinity, 50.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 5,
      ),
      child:
          isLoading
              ? CircularProgressIndicator(color: Colors.blue.shade900)
              : Text(
                text,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
    );
  }
}
