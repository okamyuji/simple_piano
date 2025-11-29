import 'package:equatable/equatable.dart';

/// レッスン難易度
enum LessonDifficulty { beginner, elementary, intermediate, advanced, expert }

/// レッスンタイプ
enum LessonType {
  noteRecognition, // 音符認識
  melody, // メロディ
  twoHands, // 両手練習
  rhythm, // リズムパターン
  song, // 曲の完成
}

/// レッスンエンティティ
class Lesson extends Equatable {
  /// レッスンID
  final String id;

  /// レッスン名
  final String title;

  /// 説明
  final String description;

  /// 難易度
  final LessonDifficulty difficulty;

  /// レッスンタイプ
  final LessonType type;

  /// レベル（1-5）
  final int level;

  /// 順序
  final int order;

  /// 練習する音符のMIDI番号リスト
  final List<int> practiceNotes;

  /// 目標達成条件（正解率パーセンテージ）
  final int targetAccuracy;

  /// 推奨練習時間（秒）
  final int recommendedDuration;

  /// 完了済みかどうか
  final bool isCompleted;

  /// ロック状態（前のレッスンを完了していない）
  final bool isLocked;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.type,
    required this.level,
    required this.order,
    required this.practiceNotes,
    this.targetAccuracy = 80,
    this.recommendedDuration = 300,
    this.isCompleted = false,
    this.isLocked = false,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    difficulty,
    type,
    level,
    order,
    practiceNotes,
    targetAccuracy,
    recommendedDuration,
    isCompleted,
    isLocked,
  ];

  /// コピーメソッド
  Lesson copyWith({
    String? id,
    String? title,
    String? description,
    LessonDifficulty? difficulty,
    LessonType? type,
    int? level,
    int? order,
    List<int>? practiceNotes,
    int? targetAccuracy,
    int? recommendedDuration,
    bool? isCompleted,
    bool? isLocked,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      type: type ?? this.type,
      level: level ?? this.level,
      order: order ?? this.order,
      practiceNotes: practiceNotes ?? this.practiceNotes,
      targetAccuracy: targetAccuracy ?? this.targetAccuracy,
      recommendedDuration: recommendedDuration ?? this.recommendedDuration,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}
