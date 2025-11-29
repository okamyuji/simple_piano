// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PracticeSessionModel _$PracticeSessionModelFromJson(
  Map<String, dynamic> json,
) => PracticeSessionModel(
  id: json['id'] as String,
  lessonId: json['lessonId'] as String?,
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  duration: (json['duration'] as num?)?.toInt() ?? 0,
  notesPlayed: (json['notesPlayed'] as num?)?.toInt() ?? 0,
  correctNotes: (json['correctNotes'] as num?)?.toInt(),
  accuracy: (json['accuracy'] as num?)?.toDouble(),
  recordingPath: json['recordingPath'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$PracticeSessionModelToJson(
  PracticeSessionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'lessonId': instance.lessonId,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime?.toIso8601String(),
  'duration': instance.duration,
  'notesPlayed': instance.notesPlayed,
  'correctNotes': instance.correctNotes,
  'accuracy': instance.accuracy,
  'recordingPath': instance.recordingPath,
  'notes': instance.notes,
};
