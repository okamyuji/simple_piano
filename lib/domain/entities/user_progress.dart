import 'package:equatable/equatable.dart';

/// ユーザー進捗エンティティ
class UserProgress extends Equatable {
  /// ユーザーID
  final String userId;

  /// 総練習時間（秒）
  final int totalPracticeTime;

  /// 連続練習日数（ストリーク）
  final int currentStreak;

  /// 最長ストリーク
  final int longestStreak;

  /// 最後の練習日
  final DateTime? lastPracticeDate;

  /// 完了したレッスンIDのリスト
  final List<String> completedLessons;

  /// 現在のレベル
  final int currentLevel;

  /// 総演奏音符数
  final int totalNotesPlayed;

  /// 達成したマイルストーン
  final List<String> achievedMilestones;

  /// 作成日時
  final DateTime createdAt;

  /// 更新日時
  final DateTime updatedAt;

  const UserProgress({
    required this.userId,
    this.totalPracticeTime = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastPracticeDate,
    this.completedLessons = const [],
    this.currentLevel = 1,
    this.totalNotesPlayed = 0,
    this.achievedMilestones = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    userId,
    totalPracticeTime,
    currentStreak,
    longestStreak,
    lastPracticeDate,
    completedLessons,
    currentLevel,
    totalNotesPlayed,
    achievedMilestones,
    createdAt,
    updatedAt,
  ];

  /// コピーメソッド
  UserProgress copyWith({
    String? userId,
    int? totalPracticeTime,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastPracticeDate,
    List<String>? completedLessons,
    int? currentLevel,
    int? totalNotesPlayed,
    List<String>? achievedMilestones,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      totalPracticeTime: totalPracticeTime ?? this.totalPracticeTime,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastPracticeDate: lastPracticeDate ?? this.lastPracticeDate,
      completedLessons: completedLessons ?? this.completedLessons,
      currentLevel: currentLevel ?? this.currentLevel,
      totalNotesPlayed: totalNotesPlayed ?? this.totalNotesPlayed,
      achievedMilestones: achievedMilestones ?? this.achievedMilestones,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// レッスン完了率を計算
  double getCompletionRate(int totalLessons) {
    if (totalLessons == 0) return 0.0;
    return (completedLessons.length / totalLessons) * 100;
  }

  /// 今日練習したかどうか
  bool get practiceToday {
    if (lastPracticeDate == null) return false;
    final now = DateTime.now();
    return lastPracticeDate!.year == now.year &&
        lastPracticeDate!.month == now.month &&
        lastPracticeDate!.day == now.day;
  }
}
