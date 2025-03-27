import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/history_provider.dart';

class HighScorePage extends StatelessWidget {
  static const routeName = '/high-score-page';
  const HighScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('High Scores', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Consumer<HistoryProvider>(
          builder: (context, historyProvider, child) {
            final scores = historyProvider.scores;
            return scores.isEmpty
                ? Center(child: Text('No scores available', style: TextStyle(fontSize: 18.sp)))
                : ListView.builder(
              itemCount: scores.length,
              itemBuilder: (context, index) {
                final score = scores[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    leading: CircleAvatar(
                      backgroundColor: index == 0 ? Colors.amber : Colors.blueAccent,
                      child: Text('${index + 1}',
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    title: Text(score['name'],
                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                    subtitle: Text('Score: ${score['score']} | Time: ${score['time']}s',
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey[700])),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}