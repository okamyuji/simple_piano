import 'package:equatable/equatable.dart';

import '../../../domain/entities/recording.dart';

/// 録音イベント基底クラス
abstract class RecordingEvent extends Equatable {
  const RecordingEvent();

  @override
  List<Object?> get props => [];
}

/// 録音一覧読み込みイベント
class RecordingLoadAllEvent extends RecordingEvent {
  const RecordingLoadAllEvent();
}

/// 録音開始イベント
class RecordingStartEvent extends RecordingEvent {
  const RecordingStartEvent();
}

/// 音符追加イベント
class RecordingAddNoteEvent extends RecordingEvent {
  final RecordedNote note;

  const RecordingAddNoteEvent({required this.note});

  @override
  List<Object?> get props => [note];
}

/// 録音停止イベント
class RecordingStopEvent extends RecordingEvent {
  final String name;

  const RecordingStopEvent({required this.name});

  @override
  List<Object?> get props => [name];
}

/// 録音キャンセルイベント
class RecordingCancelEvent extends RecordingEvent {
  const RecordingCancelEvent();
}

/// 録音再生イベント
class RecordingPlayEvent extends RecordingEvent {
  final Recording recording;

  const RecordingPlayEvent({required this.recording});

  @override
  List<Object?> get props => [recording];
}

/// 再生停止イベント
class RecordingStopPlaybackEvent extends RecordingEvent {
  const RecordingStopPlaybackEvent();
}

/// 録音削除イベント
class RecordingDeleteEvent extends RecordingEvent {
  final String recordingId;

  const RecordingDeleteEvent({required this.recordingId});

  @override
  List<Object?> get props => [recordingId];
}
