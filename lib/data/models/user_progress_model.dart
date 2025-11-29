import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_progress.dart';

part 'user_progress_model.g.dart';

/// ユーザー進捗モデル
@JsonSerializable()
class UserProgressModel extends UserProgress {
  const UserProgressModel({
    required super.userId,
    super.totalPracticeTime,
    super.currentStreak,
    super.longestStreak,
    super.lastPracticeDate,
    super.completedLessons,
    super.currentLevel,
    super.totalNotesPlayed,
    super.achievedMilestones,
    required super.createdAt,
    required super.updatedAt,
  });

  /// JSONからモデルを作成
  factory UserProgressModel.fromJson(Map<String, dynamic> json) =>
      _$UserProgressModelFromJson(json);

  /// モデルをJSONに変換
  Map<String, dynamic> toJson() => _$UserProgressModelToJson(this);

  /// エンティティからモデルを作成
  factory UserProgressModel.fromEntity(UserProgress progress) {
    return UserProgressModel(
      userId: progress.userId,
      totalPracticeTime: progress.totalPracticeTime,
      currentStreak: progress.currentStreak,
      longestStreak: progress.longestStreak,
      lastPracticeDate: progress.lastPracticeDate,
      completedLessons: progress.completedLessons,
      currentLevel: progress.currentLevel,
      totalNotesPlayed: progress.totalNotesPlayed,
      achievedMilestones: progress.achievedMilestones,
      createdAt: progress.createdAt,
      updatedAt: progress.updatedAt,
    );
  }

  /// モデルをエンティティに変換
  UserProgress toEntity() {
    return UserProgress(
      userId: userId,
      totalPracticeTime: totalPracticeTime,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastPracticeDate: lastPracticeDate,
      completedLessons: completedLessons,
      currentLevel: currentLevel,
      totalNotesPlayed: totalNotesPlayed,
      achievedMilestones: achievedMilestones,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
