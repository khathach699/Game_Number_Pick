import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/auth_provider.dart';
import 'game_mode_page.dart';
import 'high_core_page.dart';
import 'setting_page.dart';
import 'level_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple.shade700, Colors.blue.shade400],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hi, ${user!.email!.split('@')[0]}',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () => authProvider.signOut(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Game Hub',
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: const [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      50.verticalSpace,
                      _buildButton(
                        context: context,
                        title: 'Start Game',
                        onPressed:
                            () => Navigator.pushNamed(
                              context,
                              GameModePage.routeName,
                            ),
                      ),
                      20.verticalSpace,
                      _buildButton(
                        context: context,
                        title: 'Levels',
                        onPressed:
                            () => Navigator.pushNamed(
                              context,
                              LevelPage.routeName,
                            ),
                      ),
                      20.verticalSpace,
                      _buildButton(
                        context: context,
                        title: 'High Scores',
                        onPressed:
                            () => Navigator.pushNamed(
                              context,
                              HighScorePage.routeName,
                            ),
                      ),
                      20.verticalSpace,
                      _buildButton(
                        context: context,
                        title: 'Settings',
                        onPressed:
                            () => Navigator.pushNamed(
                              context,
                              SettingPage.routeName,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String title,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple.shade700,
        minimumSize: Size(220.w, 60.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        elevation: 8,
        shadowColor: Colors.black45,
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
