// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonModel _$LessonModelFromJson(Map<String, dynamic> json) => LessonModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  difficulty: $enumDecode(_$LessonDifficultyEnumMap, json['difficulty']),
  type: $enumDecode(_$LessonTypeEnumMap, json['type']),
  level: (json['level'] as num).toInt(),
  order: (json['order'] as num).toInt(),
  practiceNotes: (json['practiceNotes'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  targetAccuracy: (json['targetAccuracy'] as num?)?.toInt() ?? 80,
  recommendedDuration: (json['recommendedDuration'] as num?)?.toInt() ?? 300,
  isCompleted: json['isCompleted'] as bool? ?? false,
  isLocked: json['isLocked'] as bool? ?? false,
);

Map<String, dynamic> _$LessonModelToJson(LessonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'difficulty': _$LessonDifficultyEnumMap[instance.difficulty]!,
      'type': _$LessonTypeEnumMap[instance.type]!,
      'level': instance.level,
      'order': instance.order,
      'practiceNotes': instance.practiceNotes,
      'targetAccuracy': instance.targetAccuracy,
      'recommendedDuration': instance.recommendedDuration,
      'isCompleted': instance.isCompleted,
      'isLocked': instance.isLocked,
    };

const _$LessonDifficultyEnumMap = {
  LessonDifficulty.beginner: 'beginner',
  LessonDifficulty.elementary: 'elementary',
  LessonDifficulty.intermediate: 'intermediate',
  LessonDifficulty.advanced: 'advanced',
  LessonDifficulty.expert: 'expert',
};

const _$LessonTypeEnumMap = {
  LessonType.noteRecognition: 'noteRecognition',
  LessonType.melody: 'melody',
  LessonType.twoHands: 'twoHands',
  LessonType.rhythm: 'rhythm',
  LessonType.song: 'song',
};
