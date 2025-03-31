import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_flutter/src/pages/auth/widget/cus_tom_button.dart';
import 'package:game_flutter/src/pages/auth/widget/cus_tom_text.dart';
import 'package:game_flutter/src/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatelessWidget {
  static const String routeName = '/signup';
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, Colors.blue.shade300],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.gamepad_outlined, size: 80.sp, color: Colors.white),
                20.verticalSpace,
                Text(
                  'Sign Up Game Hub',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                40.verticalSpace,
                Consumer<AuthProvider>(
                  builder:
                      (context, authProvider, child) => Column(
                        children: [
                          CusTomText(
                            controller: authProvider.emailController,
                            hintText: "Email",
                            iconData: Icons.email,
                          ),
                          20.verticalSpace,
                          CusTomText(
                            controller: authProvider.usernameController,
                            hintText: "Username",
                            iconData: Icons.person,
                          ),
                          20.verticalSpace,
                          CusTomText(
                            controller: authProvider.passwordController,
                            hintText: "Password",
                            iconData: Icons.lock,
                            obscureText: true,
                          ),
                          20.verticalSpace,
                          CusTomText(
                            controller: authProvider.confirmPasswordController,
                            hintText: "Confirm Password",
                            iconData: Icons.lock,
                            obscureText: true,
                          ),
                          30.verticalSpace,
                          CustomButton(
                            onPressed:
                                authProvider.isLoading
                                    ? null
                                    : () async {
                                      await authProvider.signUp(context);
                                    },
                            text:
                                authProvider.isLoading
                                    ? 'Đang đăng ký...'
                                    : 'Sign Up',
                          ),
                        ],
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
