import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/practice_session.dart';

part 'practice_session_model.g.dart';

/// 練習セッションモデル
@JsonSerializable()
class PracticeSessionModel extends PracticeSession {
  const PracticeSessionModel({
    required super.id,
    super.lessonId,
    required super.startTime,
    super.endTime,
    super.duration,
    super.notesPlayed,
    super.correctNotes,
    super.accuracy,
    super.recordingPath,
    super.notes,
  });

  /// JSONからモデルを作成
  factory PracticeSessionModel.fromJson(Map<String, dynamic> json) =>
      _$PracticeSessionModelFromJson(json);

  /// モデルをJSONに変換
  Map<String, dynamic> toJson() => _$PracticeSessionModelToJson(this);

  /// エンティティからモデルを作成
  factory PracticeSessionModel.fromEntity(PracticeSession session) {
    return PracticeSessionModel(
      id: session.id,
      lessonId: session.lessonId,
      startTime: session.startTime,
      endTime: session.endTime,
      duration: session.duration,
      notesPlayed: session.notesPlayed,
      correctNotes: session.correctNotes,
      accuracy: session.accuracy,
      recordingPath: session.recordingPath,
      notes: session.notes,
    );
  }

  /// モデルをエンティティに変換
  PracticeSession toEntity() {
    return PracticeSession(
      id: id,
      lessonId: lessonId,
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      notesPlayed: notesPlayed,
      correctNotes: correctNotes,
      accuracy: accuracy,
      recordingPath: recordingPath,
      notes: notes,
    );
  }
}
