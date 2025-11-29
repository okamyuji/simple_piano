import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/routes.dart';
import '../bloc/progress/progress_bloc.dart';
import '../bloc/progress/progress_state.dart';
import '../widgets/encouragement_message.dart';

/// ホーム画面
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomePageContent();
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('シンプルピアノ'),
        actions: [
          IconButton(
            key: const Key('settings_button'),
            icon: const Icon(Icons.settings),
            tooltip: '設定',
            onPressed: () {
              Navigator.pushNamed(context, Routes.settings);
            },
          ),
        ],
      ),
      body: BlocBuilder<ProgressBloc, ProgressState>(
        builder: (context, state) {
          if (state.status == ProgressStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 励ましメッセージ
                _buildEncouragementSection(context, state),
                const SizedBox(height: 24),
                // デイリーチャレンジ
                if (state.dailyChallenge != null)
                  _buildDailyChallengeCard(context, state),
                const SizedBox(height: 24),
                // メニューグリッド
                _buildMenuGrid(context),
                const SizedBox(height: 24),
                // 進捗サマリー
                if (state.userProgress != null)
                  _buildProgressSummary(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 励ましメッセージセクション
  Widget _buildEncouragementSection(BuildContext context, ProgressState state) {
    final progress = state.userProgress;
    EncouragementType messageType;
    Map<String, dynamic>? data;

    if (progress == null || progress.totalPracticeTime == 0) {
      messageType = EncouragementType.firstPractice;
    } else if (progress.currentStreak >= 7) {
      messageType = EncouragementType.streak7Days;
    } else if (progress.currentStreak >= 3) {
      messageType = EncouragementType.streak3Days;
    } else {
      messageType = EncouragementType.encouragement;
    }

    return EncouragementMessage(type: messageType, data: data);
  }

  /// デイリーチャレンジカード
  Widget _buildDailyChallengeCard(BuildContext context, ProgressState state) {
    final challenge = state.dailyChallenge!;
    final progressPercentage = challenge.progressPercentage;

    return Card(
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text(challenge.title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(challenge.description),
                  const SizedBox(height: 16),
                  Text('目標: ${challenge.targetValue}'),
                  Text('日付: ${challenge.date}'),
                  if (challenge.isCompleted)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text('達成済み'),
                        ],
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('閉じる'),
                ),
                if (!challenge.isCompleted)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      Navigator.pushNamed(context, '/piano');
                    },
                    child: const Text('練習開始'),
                  ),
              ],
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '今日のチャレンジ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          challenge.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  if (challenge.isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 32,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                challenge.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progressPercentage / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  challenge.isCompleted ? Colors.green : Colors.amber,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '進捗: ${challenge.currentValue}/${challenge.targetValue}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// メニューグリッド
  Widget _buildMenuGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildMenuCard(
          context,
          icon: Icons.piano,
          title: '自由演奏',
          subtitle: 'ピアノを弾く',
          color: Colors.blue,
          onTap: () => Navigator.pushNamed(context, Routes.piano),
        ),
        _buildMenuCard(
          context,
          icon: Icons.school,
          title: 'レッスン',
          subtitle: '学習する',
          color: Colors.green,
          onTap: () => Navigator.pushNamed(context, Routes.lesson),
        ),
        _buildMenuCard(
          context,
          icon: Icons.bar_chart,
          title: '進捗',
          subtitle: '記録を見る',
          color: Colors.orange,
          onTap: () => Navigator.pushNamed(context, Routes.progress),
        ),
        _buildMenuCard(
          context,
          icon: Icons.settings,
          title: '設定',
          subtitle: 'カスタマイズ',
          color: Colors.purple,
          onTap: () => Navigator.pushNamed(context, Routes.settings),
        ),
      ],
    );
  }

  /// メニューカード
  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: title,
      button: true,
      enabled: true,
      child: Card(
        key: Key('menu_card_$title'),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 36),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  key: Key('menu_title_$title'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  key: Key('menu_subtitle_$title'),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 進捗サマリー
  Widget _buildProgressSummary(BuildContext context, ProgressState state) {
    final progress = state.userProgress!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('あなたの記録', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  icon: Icons.local_fire_department,
                  value: '${progress.currentStreak}',
                  label: '連続日数',
                  color: Colors.orange,
                ),
                _buildStatItem(
                  context,
                  icon: Icons.timer,
                  value: '${progress.totalPracticeTime ~/ 60}',
                  label: '練習分数',
                  color: Colors.green,
                ),
                _buildStatItem(
                  context,
                  icon: Icons.music_note,
                  value: '${progress.totalNotesPlayed}',
                  label: '演奏音符',
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 統計アイテム
  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
