import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    super.key,
    required this.title,
    this.icon = "assets/icons/2.png",
    this.isEnable = false,
    this.onPressed,
  });

  final String title, icon;
  final bool isEnable;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20.r),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.yellowAccent,
        onTap: onPressed,
        child: Ink(
          width: 214.dg,
          height: 69.dg,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: const Color(0xff1fc5ea),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isEnable ? Image.asset(icon) : SizedBox.shrink(),
              15.horizontalSpace,
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
