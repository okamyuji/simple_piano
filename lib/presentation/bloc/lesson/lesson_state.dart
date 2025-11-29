import 'package:equatable/equatable.dart';

import '../../../domain/entities/lesson.dart';

/// レッスンステータス
enum LessonStatus { initial, loading, loaded, inProgress, completed, error }

/// レッスンステート
class LessonState extends Equatable {
  /// ステータス
  final LessonStatus status;

  /// レッスン一覧
  final List<Lesson> lessons;

  /// 現在選択中のレッスン
  final Lesson? currentLesson;

  /// 正解数
  final int correctCount;

  /// 不正解数
  final int incorrectCount;

  /// 現在の問題インデックス
  final int currentQuestionIndex;

  /// レッスン開始時刻
  final DateTime? startTime;

  /// エラーメッセージ
  final String? errorMessage;

  const LessonState({
    this.status = LessonStatus.initial,
    this.lessons = const [],
    this.currentLesson,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.currentQuestionIndex = 0,
    this.startTime,
    this.errorMessage,
  });

  /// コピーメソッド
  LessonState copyWith({
    LessonStatus? status,
    List<Lesson>? lessons,
    Lesson? currentLesson,
    int? correctCount,
    int? incorrectCount,
    int? currentQuestionIndex,
    DateTime? startTime,
    String? errorMessage,
  }) {
    return LessonState(
      status: status ?? this.status,
      lessons: lessons ?? this.lessons,
      currentLesson: currentLesson ?? this.currentLesson,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      startTime: startTime ?? this.startTime,
      errorMessage: errorMessage,
    );
  }

  /// 正解率を計算
  double get accuracy {
    final total = correctCount + incorrectCount;
    if (total == 0) return 0.0;
    return (correctCount / total * 100);
  }

  /// レッスンが進行中かどうか
  bool get isInProgress => status == LessonStatus.inProgress;

  /// レッスンが完了したかどうか
  bool get isCompleted => status == LessonStatus.completed;

  @override
  List<Object?> get props => [
    status,
    lessons,
    currentLesson,
    correctCount,
    incorrectCount,
    currentQuestionIndex,
    startTime,
    errorMessage,
  ];
}
