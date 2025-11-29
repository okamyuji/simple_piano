import 'package:equatable/equatable.dart';

/// 練習セッションエンティティ
class PracticeSession extends Equatable {
  /// セッションID
  final String id;

  /// レッスンID（オプション）
  final String? lessonId;

  /// 開始時刻
  final DateTime startTime;

  /// 終了時刻
  final DateTime? endTime;

  /// 練習時間（秒）
  final int duration;

  /// 演奏した音符の数
  final int notesPlayed;

  /// 正解した音符の数（レッスンの場合）
  final int? correctNotes;

  /// 正解率（パーセンテージ）
  final double? accuracy;

  /// 録音ファイルパス（オプション）
  final String? recordingPath;

  /// メモ
  final String? notes;

  const PracticeSession({
    required this.id,
    this.lessonId,
    required this.startTime,
    this.endTime,
    this.duration = 0,
    this.notesPlayed = 0,
    this.correctNotes,
    this.accuracy,
    this.recordingPath,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    lessonId,
    startTime,
    endTime,
    duration,
    notesPlayed,
    correctNotes,
    accuracy,
    recordingPath,
    notes,
  ];

  /// コピーメソッド
  PracticeSession copyWith({
    String? id,
    String? lessonId,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    int? notesPlayed,
    int? correctNotes,
    double? accuracy,
    String? recordingPath,
    String? notes,
  }) {
    return PracticeSession(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      notesPlayed: notesPlayed ?? this.notesPlayed,
      correctNotes: correctNotes ?? this.correctNotes,
      accuracy: accuracy ?? this.accuracy,
      recordingPath: recordingPath ?? this.recordingPath,
      notes: notes ?? this.notes,
    );
  }

  /// セッションが進行中かどうか
  bool get isActive => endTime == null;

  /// セッションが完了しているかどうか
  bool get isCompleted => endTime != null;
}
