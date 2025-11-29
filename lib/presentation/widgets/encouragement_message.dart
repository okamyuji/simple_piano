import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 励ましメッセージウィジェット
class EncouragementMessage extends StatelessWidget {
  final EncouragementType type;
  final Map<String, dynamic>? data;

  const EncouragementMessage({super.key, required this.type, this.data});

  @override
  Widget build(BuildContext context) {
    final message = _getMessage(type, data);
    final icon = _getIcon(type);
    final color = _getColor(type);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// メッセージを取得
  String _getMessage(EncouragementType type, Map<String, dynamic>? data) {
    switch (type) {
      case EncouragementType.firstPractice:
        return '素晴らしい第一歩です！音楽の旅が始まりました🎵';
      case EncouragementType.practiceComplete:
        final minutes = data?['minutes'] ?? 5;
        return '$minutes分の練習お疲れ様でした！集中力抜群ですね！';
      case EncouragementType.streak3Days:
        return '3日連続達成！習慣化への道を順調に進んでいます✨';
      case EncouragementType.streak7Days:
        return '1週間継続は立派な成果！あなたはもうピアニストです🎹';
      case EncouragementType.lessonComplete:
        final lessonName = data?['lessonName'] ?? 'レッスン';
        return '$lessonNameを完了しました！次のステップへ進みましょう！';
      case EncouragementType.highAccuracy:
        final accuracy = data?['accuracy'] ?? 90;
        return '正解率$accuracy%達成！素晴らしい演奏です👏';
      case EncouragementType.milestone:
        final milestone = data?['milestone'] ?? 'マイルストーン';
        return '$milestone達成おめでとうございます！🎉';
      case EncouragementType.encouragement:
        return _getRandomEncouragement();
      case EncouragementType.difficulty:
        return '難しいところこそ成長のチャンス。ゆっくりで大丈夫です🌱';
    }
  }

  /// ランダムな励ましメッセージを取得
  String _getRandomEncouragement() {
    final messages = [
      '毎日の積み重ねが大きな成果につながります',
      'あなたのペースで進んでいきましょう',
      '音楽を楽しむことが一番大切です',
      '小さな進歩も立派な成長です',
      '継続は力なり。一緒に頑張りましょう',
      '今日も素敵な音楽の時間を過ごしましょう',
      'あなたの努力は必ず実を結びます',
      '楽しみながら上達していきましょう',
    ];
    return messages[math.Random().nextInt(messages.length)];
  }

  /// アイコンを取得
  IconData _getIcon(EncouragementType type) {
    switch (type) {
      case EncouragementType.firstPractice:
        return Icons.celebration;
      case EncouragementType.practiceComplete:
        return Icons.check_circle;
      case EncouragementType.streak3Days:
      case EncouragementType.streak7Days:
        return Icons.local_fire_department;
      case EncouragementType.lessonComplete:
        return Icons.school;
      case EncouragementType.highAccuracy:
        return Icons.star;
      case EncouragementType.milestone:
        return Icons.emoji_events;
      case EncouragementType.encouragement:
        return Icons.favorite;
      case EncouragementType.difficulty:
        return Icons.psychology;
    }
  }

  /// カラーを取得
  Color _getColor(EncouragementType type) {
    switch (type) {
      case EncouragementType.firstPractice:
        return Colors.purple;
      case EncouragementType.practiceComplete:
        return Colors.green;
      case EncouragementType.streak3Days:
      case EncouragementType.streak7Days:
        return Colors.orange;
      case EncouragementType.lessonComplete:
        return Colors.blue;
      case EncouragementType.highAccuracy:
        return Colors.amber;
      case EncouragementType.milestone:
        return Colors.deepPurple;
      case EncouragementType.encouragement:
        return Colors.pink;
      case EncouragementType.difficulty:
        return Colors.teal;
    }
  }
}

/// 励ましメッセージタイプ
enum EncouragementType {
  firstPractice,
  practiceComplete,
  streak3Days,
  streak7Days,
  lessonComplete,
  highAccuracy,
  milestone,
  encouragement,
  difficulty,
}
