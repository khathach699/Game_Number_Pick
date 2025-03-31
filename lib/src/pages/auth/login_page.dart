import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_flutter/src/pages/auth/signup_page.dart';
import 'package:game_flutter/src/pages/auth/widget/cus_tom_button.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();
    final password = TextEditingController();
    final authProvider = Provider.of<AuthProvider>(context);

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
                  'Welcome to Game Hub',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                40.verticalSpace,
                TextField(
                  controller: email,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.email, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                20.verticalSpace,
                TextField(
                  controller: password,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                30.verticalSpace,
                CustomButton(
                  onPressed:
                      authProvider.isLoading
                          ? null
                          : () => authProvider.signIn(
                            email.text.trim(),
                            password.text.trim(),
                          ),

                  text: authProvider.isLoading ? "Loading..." : "Login",
                ),
                20.verticalSpace,
                CustomButton(
                  onPressed:
                      () => Navigator.pushNamed(context, SignupPage.routeName),
                  text: "SignUp",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
