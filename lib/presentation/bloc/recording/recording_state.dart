import 'package:equatable/equatable.dart';

import '../../../domain/entities/recording.dart';

/// 録音ステータス
enum RecordingStatus {
  initial,
  loading,
  loaded,
  recording,
  playing,
  stopped,
  error,
}

/// 録音ステート
class RecordingState extends Equatable {
  /// ステータス
  final RecordingStatus status;

  /// 録音一覧
  final List<Recording> recordings;

  /// 現在の録音ID
  final String? currentRecordingId;

  /// 現在再生中の録音
  final Recording? playingRecording;

  /// エラーメッセージ
  final String? errorMessage;

  const RecordingState({
    this.status = RecordingStatus.initial,
    this.recordings = const [],
    this.currentRecordingId,
    this.playingRecording,
    this.errorMessage,
  });

  /// コピーメソッド
  RecordingState copyWith({
    RecordingStatus? status,
    List<Recording>? recordings,
    String? currentRecordingId,
    Recording? playingRecording,
    String? errorMessage,
  }) {
    return RecordingState(
      status: status ?? this.status,
      recordings: recordings ?? this.recordings,
      currentRecordingId: currentRecordingId ?? this.currentRecordingId,
      playingRecording: playingRecording ?? this.playingRecording,
      errorMessage: errorMessage,
    );
  }

  /// 録音中かどうか
  bool get isRecording => status == RecordingStatus.recording;

  /// 再生中かどうか
  bool get isPlaying => status == RecordingStatus.playing;

  @override
  List<Object?> get props => [
    status,
    recordings,
    currentRecordingId,
    playingRecording,
    errorMessage,
  ];
}
