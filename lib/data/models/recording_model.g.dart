// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordedNoteModel _$RecordedNoteModelFromJson(Map<String, dynamic> json) =>
    RecordedNoteModel(
      midiNumber: (json['midiNumber'] as num).toInt(),
      startTime: (json['startTime'] as num).toInt(),
      endTime: (json['endTime'] as num).toInt(),
      velocity: (json['velocity'] as num?)?.toInt() ?? 64,
    );

Map<String, dynamic> _$RecordedNoteModelToJson(RecordedNoteModel instance) =>
    <String, dynamic>{
      'midiNumber': instance.midiNumber,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'velocity': instance.velocity,
    };

RecordingModel _$RecordingModelFromJson(Map<String, dynamic> json) =>
    RecordingModel(
      id: json['id'] as String,
      name: json['name'] as String,
      notes: (json['notes'] as List<dynamic>)
          .map((e) => RecordedNoteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      totalDuration: (json['totalDuration'] as num).toInt(),
      tempo: (json['tempo'] as num?)?.toInt() ?? 120,
      filePath: json['filePath'] as String?,
    );

Map<String, dynamic> _$RecordingModelToJson(RecordingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'notes': instance.notes.map((e) => e.toJson()).toList(),
      'recordedAt': instance.recordedAt.toIso8601String(),
      'totalDuration': instance.totalDuration,
      'tempo': instance.tempo,
      'filePath': instance.filePath,
    };
