import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/repositories/lesson_repository.dart';
import '../../../domain/usecases/get_lessons.dart';
import 'lesson_event.dart';
import 'lesson_state.dart';

/// レッスンBLoC
@injectable
class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final GetLessons getLessonsUseCase;
  final LessonRepository lessonRepository;

  LessonBloc({required this.getLessonsUseCase, required this.lessonRepository})
    : super(const LessonState()) {
    on<LessonLoadAllEvent>(_onLoadAll);
    on<LessonLoadByLevelEvent>(_onLoadByLevel);
    on<LessonSelectEvent>(_onSelect);
    on<LessonStartEvent>(_onStart);
    on<LessonCompleteEvent>(_onComplete);
    on<LessonCorrectNoteEvent>(_onCorrectNote);
    on<LessonIncorrectNoteEvent>(_onIncorrectNote);
    on<LessonResetEvent>(_onReset);
  }

  /// すべてのレッスンを読み込み
  Future<void> _onLoadAll(
    LessonLoadAllEvent event,
    Emitter<LessonState> emit,
  ) async {
    emit(state.copyWith(status: LessonStatus.loading));

    final result = await getLessonsUseCase(const GetLessonsParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LessonStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (lessons) =>
          emit(state.copyWith(status: LessonStatus.loaded, lessons: lessons)),
    );
  }

  /// レベル別にレッスンを読み込み
  Future<void> _onLoadByLevel(
    LessonLoadByLevelEvent event,
    Emitter<LessonState> emit,
  ) async {
    emit(state.copyWith(status: LessonStatus.loading));

    final result = await getLessonsUseCase(
      GetLessonsParams(level: event.level),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LessonStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (lessons) =>
          emit(state.copyWith(status: LessonStatus.loaded, lessons: lessons)),
    );
  }

  /// レッスンを選択
  Future<void> _onSelect(
    LessonSelectEvent event,
    Emitter<LessonState> emit,
  ) async {
    final result = await lessonRepository.getLessonById(event.lessonId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LessonStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (lesson) => emit(
        state.copyWith(currentLesson: lesson, status: LessonStatus.loaded),
      ),
    );
  }

  /// レッスンを開始
  Future<void> _onStart(
    LessonStartEvent event,
    Emitter<LessonState> emit,
  ) async {
    if (state.currentLesson == null) {
      // レッスンが選択されていない場合は選択してから開始
      final result = await lessonRepository.getLessonById(event.lessonId);

      await result.fold(
        (failure) async => emit(
          state.copyWith(
            status: LessonStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (lesson) async => emit(
          state.copyWith(
            currentLesson: lesson,
            status: LessonStatus.inProgress,
            startTime: DateTime.now(),
            correctCount: 0,
            incorrectCount: 0,
            currentQuestionIndex: 0,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: LessonStatus.inProgress,
          startTime: DateTime.now(),
          correctCount: 0,
          incorrectCount: 0,
          currentQuestionIndex: 0,
        ),
      );
    }
  }

  /// レッスンを完了
  Future<void> _onComplete(
    LessonCompleteEvent event,
    Emitter<LessonState> emit,
  ) async {
    debugPrint(
      '[LessonBloc] レッスン完了イベント受信: ${event.lessonId}, 精度: ${event.accuracy}%',
    );

    // 進捗を保存
    final result = await lessonRepository.saveLessonProgress(
      event.lessonId,
      event.accuracy,
    );

    result.fold(
      (failure) {
        debugPrint('[LessonBloc] 保存失敗: ${failure.message}');
        emit(
          state.copyWith(
            status: LessonStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        debugPrint('[LessonBloc] 保存成功');
        emit(state.copyWith(status: LessonStatus.completed));
      },
    );
  }

  /// 正解音符
  Future<void> _onCorrectNote(
    LessonCorrectNoteEvent event,
    Emitter<LessonState> emit,
  ) async {
    if (!state.isInProgress) return;

    emit(
      state.copyWith(
        correctCount: state.correctCount + 1,
        currentQuestionIndex: state.currentQuestionIndex + 1,
      ),
    );

    // レッスンの全問題が終了したかチェック
    if (state.currentLesson != null &&
        state.currentQuestionIndex >=
            state.currentLesson!.practiceNotes.length) {
      // 自動完了
      add(
        LessonCompleteEvent(
          lessonId: state.currentLesson!.id,
          accuracy: state.accuracy.round(),
        ),
      );
    }
  }

  /// 不正解音符
  Future<void> _onIncorrectNote(
    LessonIncorrectNoteEvent event,
    Emitter<LessonState> emit,
  ) async {
    if (!state.isInProgress) return;

    emit(state.copyWith(incorrectCount: state.incorrectCount + 1));
  }

  /// レッスンをリセット
  Future<void> _onReset(
    LessonResetEvent event,
    Emitter<LessonState> emit,
  ) async {
    emit(
      state.copyWith(
        status: LessonStatus.loaded,
        correctCount: 0,
        incorrectCount: 0,
        currentQuestionIndex: 0,
        startTime: null,
      ),
    );
  }
}
