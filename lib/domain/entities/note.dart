import 'package:equatable/equatable.dart';

/// 音符エンティティ
class Note extends Equatable {
  /// MIDIノート番号
  final int midiNumber;

  /// 音符名（例: C4, D#5）
  final String noteName;

  /// オクターブ
  final int octave;

  /// 周波数（Hz）
  final double frequency;

  /// 白鍵かどうか
  final bool isWhiteKey;

  const Note({
    required this.midiNumber,
    required this.noteName,
    required this.octave,
    required this.frequency,
    required this.isWhiteKey,
  });

  @override
  List<Object?> get props => [
    midiNumber,
    noteName,
    octave,
    frequency,
    isWhiteKey,
  ];

  /// コピーメソッド
  Note copyWith({
    int? midiNumber,
    String? noteName,
    int? octave,
    double? frequency,
    bool? isWhiteKey,
  }) {
    return Note(
      midiNumber: midiNumber ?? this.midiNumber,
      noteName: noteName ?? this.noteName,
      octave: octave ?? this.octave,
      frequency: frequency ?? this.frequency,
      isWhiteKey: isWhiteKey ?? this.isWhiteKey,
    );
  }
}
