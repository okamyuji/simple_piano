import 'package:flutter/material.dart';

import '../../domain/entities/user_progress.dart';

/// 進捗チャートウィジェット
class ProgressChart extends StatelessWidget {
  final UserProgress progress;
  final int totalLessons;

  const ProgressChart({
    super.key,
    required this.progress,
    this.totalLessons = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('あなたの進捗', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            // レッスン完了率
            _buildProgressItem(
              context,
              icon: Icons.school,
              label: 'レッスン完了',
              value: '${progress.completedLessons.length}/$totalLessons',
              progress: progress.getCompletionRate(totalLessons) / 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            // 総練習時間
            _buildProgressItem(
              context,
              icon: Icons.timer,
              label: '総練習時間',
              value: _formatDuration(progress.totalPracticeTime),
              progress: null,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            // 連続練習日数
            _buildProgressItem(
              context,
              icon: Icons.local_fire_department,
              label: '連続練習',
              value: '${progress.currentStreak}日',
              progress: null,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            // 総演奏音符数
            _buildProgressItem(
              context,
              icon: Icons.music_note,
              label: '総演奏音符',
              value: '${progress.totalNotesPlayed}音',
              progress: null,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  /// 進捗アイテムを構築
  Widget _buildProgressItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    double? progress,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              if (progress != null) ...[
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: color.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// 時間をフォーマット
  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    if (hours > 0) {
      return '$hours時間$minutes分';
    } else {
      return '$minutes分';
    }
  }
}
