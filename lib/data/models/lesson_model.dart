import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/lesson.dart';

part 'lesson_model.g.dart';

/// レッスンモデル
@JsonSerializable()
class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.title,
    required super.description,
    required super.difficulty,
    required super.type,
    required super.level,
    required super.order,
    required super.practiceNotes,
    super.targetAccuracy,
    super.recommendedDuration,
    super.isCompleted,
    super.isLocked,
  });

  /// JSONからモデルを作成
  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);

  /// モデルをJSONに変換
  Map<String, dynamic> toJson() => _$LessonModelToJson(this);

  /// エンティティからモデルを作成
  factory LessonModel.fromEntity(Lesson lesson) {
    return LessonModel(
      id: lesson.id,
      title: lesson.title,
      description: lesson.description,
      difficulty: lesson.difficulty,
      type: lesson.type,
      level: lesson.level,
      order: lesson.order,
      practiceNotes: lesson.practiceNotes,
      targetAccuracy: lesson.targetAccuracy,
      recommendedDuration: lesson.recommendedDuration,
      isCompleted: lesson.isCompleted,
      isLocked: lesson.isLocked,
    );
  }

  /// モデルをエンティティに変換
  Lesson toEntity() {
    return Lesson(
      id: id,
      title: title,
      description: description,
      difficulty: difficulty,
      type: type,
      level: level,
      order: order,
      practiceNotes: practiceNotes,
      targetAccuracy: targetAccuracy,
      recommendedDuration: recommendedDuration,
      isCompleted: isCompleted,
      isLocked: isLocked,
    );
  }
}
