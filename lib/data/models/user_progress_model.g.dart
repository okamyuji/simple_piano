// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProgressModel _$UserProgressModelFromJson(Map<String, dynamic> json) =>
    UserProgressModel(
      userId: json['userId'] as String,
      totalPracticeTime: (json['totalPracticeTime'] as num?)?.toInt() ?? 0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      lastPracticeDate: json['lastPracticeDate'] == null
          ? null
          : DateTime.parse(json['lastPracticeDate'] as String),
      completedLessons:
          (json['completedLessons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      currentLevel: (json['currentLevel'] as num?)?.toInt() ?? 1,
      totalNotesPlayed: (json['totalNotesPlayed'] as num?)?.toInt() ?? 0,
      achievedMilestones:
          (json['achievedMilestones'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserProgressModelToJson(UserProgressModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'totalPracticeTime': instance.totalPracticeTime,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'lastPracticeDate': instance.lastPracticeDate?.toIso8601String(),
      'completedLessons': instance.completedLessons,
      'currentLevel': instance.currentLevel,
      'totalNotesPlayed': instance.totalNotesPlayed,
      'achievedMilestones': instance.achievedMilestones,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
