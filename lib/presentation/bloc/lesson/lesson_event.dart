import 'package:equatable/equatable.dart';

/// レッスンイベント基底クラス
abstract class LessonEvent extends Equatable {
  const LessonEvent();

  @override
  List<Object?> get props => [];
}

/// レッスン一覧取得イベント
class LessonLoadAllEvent extends LessonEvent {
  const LessonLoadAllEvent();
}

/// レベル別レッスン取得イベント
class LessonLoadByLevelEvent extends LessonEvent {
  final int level;

  const LessonLoadByLevelEvent({required this.level});

  @override
  List<Object?> get props => [level];
}

/// レッスン選択イベント
class LessonSelectEvent extends LessonEvent {
  final String lessonId;

  const LessonSelectEvent({required this.lessonId});

  @override
  List<Object?> get props => [lessonId];
}

/// レッスン開始イベント
class LessonStartEvent extends LessonEvent {
  final String lessonId;

  const LessonStartEvent({required this.lessonId});

  @override
  List<Object?> get props => [lessonId];
}

/// レッスン完了イベント
class LessonCompleteEvent extends LessonEvent {
  final String lessonId;
  final int accuracy;

  const LessonCompleteEvent({required this.lessonId, required this.accuracy});

  @override
  List<Object?> get props => [lessonId, accuracy];
}

/// 正解音符イベント
class LessonCorrectNoteEvent extends LessonEvent {
  final int midiNumber;

  const LessonCorrectNoteEvent({required this.midiNumber});

  @override
  List<Object?> get props => [midiNumber];
}

/// 不正解音符イベント
class LessonIncorrectNoteEvent extends LessonEvent {
  final int midiNumber;

  const LessonIncorrectNoteEvent({required this.midiNumber});

  @override
  List<Object?> get props => [midiNumber];
}

/// レッスンリセットイベント
class LessonResetEvent extends LessonEvent {
  const LessonResetEvent();
}
