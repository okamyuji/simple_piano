import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/recording.dart';

part 'recording_model.g.dart';

/// 録音された音符モデル
@JsonSerializable()
class RecordedNoteModel extends RecordedNote {
  const RecordedNoteModel({
    required super.midiNumber,
    required super.startTime,
    required super.endTime,
    super.velocity,
  });

  /// JSONからモデルを作成
  factory RecordedNoteModel.fromJson(Map<String, dynamic> json) =>
      _$RecordedNoteModelFromJson(json);

  /// モデルをJSONに変換
  Map<String, dynamic> toJson() => _$RecordedNoteModelToJson(this);

  /// エンティティからモデルを作成
  factory RecordedNoteModel.fromEntity(RecordedNote note) {
    return RecordedNoteModel(
      midiNumber: note.midiNumber,
      startTime: note.startTime,
      endTime: note.endTime,
      velocity: note.velocity,
    );
  }

  /// モデルをエンティティに変換
  RecordedNote toEntity() {
    return RecordedNote(
      midiNumber: midiNumber,
      startTime: startTime,
      endTime: endTime,
      velocity: velocity,
    );
  }
}

/// 録音モデル
@JsonSerializable(explicitToJson: true)
class RecordingModel {
  final String id;
  final String name;
  final List<RecordedNoteModel> notes;
  final DateTime recordedAt;
  final int totalDuration;
  final int tempo;
  final String? filePath;

  const RecordingModel({
    required this.id,
    required this.name,
    required this.notes,
    required this.recordedAt,
    required this.totalDuration,
    this.tempo = 120,
    this.filePath,
  });

  /// JSONからモデルを作成
  factory RecordingModel.fromJson(Map<String, dynamic> json) =>
      _$RecordingModelFromJson(json);

  /// モデルをJSONに変換
  Map<String, dynamic> toJson() => _$RecordingModelToJson(this);

  /// エンティティからモデルを作成
  factory RecordingModel.fromEntity(Recording recording) {
    return RecordingModel(
      id: recording.id,
      name: recording.name,
      notes: recording.notes
          .map((note) => RecordedNoteModel.fromEntity(note))
          .toList(),
      recordedAt: recording.recordedAt,
      totalDuration: recording.totalDuration,
      tempo: recording.tempo,
      filePath: recording.filePath,
    );
  }

  /// モデルをエンティティに変換
  Recording toEntity() {
    return Recording(
      id: id,
      name: name,
      notes: notes.map((note) => note.toEntity()).toList(),
      recordedAt: recordedAt,
      totalDuration: totalDuration,
      tempo: tempo,
      filePath: filePath,
    );
  }
}
