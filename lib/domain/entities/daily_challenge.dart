import 'package:equatable/equatable.dart';

/// デイリーチャレンジタイプ
enum ChallengeType {
  practiceTime, // 練習時間
  noteCount, // 音符数
  accuracy, // 正解率
  streak, // 連続日数
  lessonCompletion, // レッスン完了
}

/// デイリーチャレンジエンティティ
class DailyChallenge extends Equatable {
  /// チャレンジID
  final String id;

  /// チャレンジ名
  final String title;

  /// 説明
  final String description;

  /// チャレンジタイプ
  final ChallengeType type;

  /// 目標値
  final int targetValue;

  /// 現在の進捗値
  final int currentValue;

  /// 報酬ポイント
  final int rewardPoints;

  /// 日付
  final DateTime date;

  /// 完了済みかどうか
  final bool isCompleted;

  const DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    this.currentValue = 0,
    this.rewardPoints = 10,
    required this.date,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    targetValue,
    currentValue,
    rewardPoints,
    date,
    isCompleted,
  ];

  /// コピーメソッド
  DailyChallenge copyWith({
    String? id,
    String? title,
    String? description,
    ChallengeType? type,
    int? targetValue,
    int? currentValue,
    int? rewardPoints,
    DateTime? date,
    bool? isCompleted,
  }) {
    return DailyChallenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// 進捗率を計算
  double get progressPercentage {
    if (targetValue == 0) return 0.0;
    return (currentValue / targetValue * 100).clamp(0.0, 100.0);
  }

  /// 今日のチャレンジかどうか
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
