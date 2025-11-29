import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/note.dart';

part 'note_model.g.dart';

/// 音符モデル
@JsonSerializable()
class NoteModel extends Note {
  const NoteModel({
    required super.midiNumber,
    required super.noteName,
    required super.octave,
    required super.frequency,
    required super.isWhiteKey,
  });

  /// JSONからモデルを作成
  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  /// モデルをJSONに変換
  Map<String, dynamic> toJson() => _$NoteModelToJson(this);

  /// エンティティからモデルを作成
  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      midiNumber: note.midiNumber,
      noteName: note.noteName,
      octave: note.octave,
      frequency: note.frequency,
      isWhiteKey: note.isWhiteKey,
    );
  }

  /// モデルをエンティティに変換
  Note toEntity() {
    return Note(
      midiNumber: midiNumber,
      noteName: noteName,
      octave: octave,
      frequency: frequency,
      isWhiteKey: isWhiteKey,
    );
  }
}
