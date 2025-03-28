import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/audio_provider.dart';

class SettingPage extends StatelessWidget {
  static const routeName = '/setting-page';
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Consumer<AudioProvider>(
          builder: (context, audioProvider, child) {
            return Column(
              children: [
                SwitchListTile(
                  title: const Text("Background Music (GamePage)"),
                  value: audioProvider.isMusicEnabled,
                  onChanged: (value) {
                    audioProvider.toggleMusic(value);
                  },
                ),
                SwitchListTile(
                  title: const Text("Button Sound"),
                  value: audioProvider.isSoundEnabled,
                  onChanged: (value) {
                    audioProvider.toggleSound(value);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}