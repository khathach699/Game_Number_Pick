import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CusTomText extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final IconData? iconData;
  final bool? obscureText;
  const CusTomText({
    super.key,
    this.controller,
    this.hintText,
    this.iconData,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText ?? false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(iconData, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
