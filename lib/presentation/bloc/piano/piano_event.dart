import 'package:equatable/equatable.dart';

import '../../../domain/entities/note.dart';

/// ピアノイベント基底クラス
abstract class PianoEvent extends Equatable {
  const PianoEvent();

  @override
  List<Object?> get props => [];
}

/// ピアノ初期化イベント
class PianoInitializeEvent extends PianoEvent {
  const PianoInitializeEvent();
}

/// 音符押下イベント
class PianoKeyPressedEvent extends PianoEvent {
  final Note note;
  final double velocity;

  const PianoKeyPressedEvent({required this.note, this.velocity = 1.0});

  @override
  List<Object?> get props => [note, velocity];
}

/// 音符リリースイベント
class PianoKeyReleasedEvent extends PianoEvent {
  final Note note;

  const PianoKeyReleasedEvent({required this.note});

  @override
  List<Object?> get props => [note];
}

/// すべての音を停止イベント
class PianoStopAllNotesEvent extends PianoEvent {
  const PianoStopAllNotesEvent();
}

/// ボリューム変更イベント
class PianoVolumeChangedEvent extends PianoEvent {
  final double volume;

  const PianoVolumeChangedEvent({required this.volume});

  @override
  List<Object?> get props => [volume];
}

/// オクターブ変更イベント
class PianoOctaveChangedEvent extends PianoEvent {
  final int octave;

  const PianoOctaveChangedEvent({required this.octave});

  @override
  List<Object?> get props => [octave];
}

/// ピアノ破棄イベント
class PianoDisposeEvent extends PianoEvent {
  const PianoDisposeEvent();
}
