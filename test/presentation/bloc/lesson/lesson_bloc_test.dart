import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_piano/core/errors/failures.dart';
import 'package:simple_piano/domain/entities/lesson.dart';
import 'package:simple_piano/domain/repositories/lesson_repository.dart';
import 'package:simple_piano/domain/usecases/get_lessons.dart';
import 'package:simple_piano/presentation/bloc/lesson/lesson_bloc.dart';
import 'package:simple_piano/presentation/bloc/lesson/lesson_event.dart';
import 'package:simple_piano/presentation/bloc/lesson/lesson_state.dart';

import 'lesson_bloc_test.mocks.dart';

@GenerateMocks([LessonRepository, GetLessons])
void main() {
  late MockLessonRepository mockLessonRepository;
  late MockGetLessons mockGetLessons;
  late LessonBloc lessonBloc;

  setUp(() {
    mockLessonRepository = MockLessonRepository();
    mockGetLessons = MockGetLessons();
    lessonBloc = LessonBloc(
      lessonRepository: mockLessonRepository,
      getLessonsUseCase: mockGetLessons,
    );
  });

  tearDown(() {
    lessonBloc.close();
  });

  group('LessonCompleteEvent', () {
    const testLessonId = 'lesson_1_1';
    const testAccuracy = 100;

    final testLesson = Lesson(
      id: testLessonId,
      title: 'テストレッスン',
      description: 'テスト用',
      difficulty: LessonDifficulty.beginner,
      type: LessonType.noteRecognition,
      level: 1,
      order: 1,
      practiceNotes: const [60, 62, 64],
      targetAccuracy: 80,
      isCompleted: false,
      isLocked: false,
    );

    test('初期状態はinitial', () {
      expect(lessonBloc.state.status, LessonStatus.initial);
      expect(lessonBloc.state.lessons, isEmpty);
    });

    blocTest<LessonBloc, LessonState>(
      'LessonCompleteEventが成功した場合、statusがcompletedになる',
      build: () {
        when(
          mockLessonRepository.saveLessonProgress(testLessonId, testAccuracy),
        ).thenAnswer((_) async => const Right(null));
        return lessonBloc;
      },
      act: (bloc) => bloc.add(
        const LessonCompleteEvent(
          lessonId: testLessonId,
          accuracy: testAccuracy,
        ),
      ),
      expect: () => [const LessonState(status: LessonStatus.completed)],
      verify: (_) {
        verify(
          mockLessonRepository.saveLessonProgress(testLessonId, testAccuracy),
        ).called(1);
      },
    );

    blocTest<LessonBloc, LessonState>(
      'LessonCompleteEventが失敗した場合、statusがerrorになる',
      build: () {
        when(
          mockLessonRepository.saveLessonProgress(testLessonId, testAccuracy),
        ).thenAnswer((_) async => const Left(CacheFailure('保存に失敗しました')));
        return lessonBloc;
      },
      act: (bloc) => bloc.add(
        const LessonCompleteEvent(
          lessonId: testLessonId,
          accuracy: testAccuracy,
        ),
      ),
      expect: () => [
        const LessonState(
          status: LessonStatus.error,
          errorMessage: '保存に失敗しました',
        ),
      ],
      verify: (_) {
        verify(
          mockLessonRepository.saveLessonProgress(testLessonId, testAccuracy),
        ).called(1);
      },
    );

    blocTest<LessonBloc, LessonState>(
      'saveLessonProgressが目標達成率でmarkLessonCompleteを呼ぶことを確認',
      build: () {
        when(
          mockLessonRepository.getLessonById(testLessonId),
        ).thenAnswer((_) async => Right(testLesson));
        when(
          mockLessonRepository.markLessonComplete(testLessonId),
        ).thenAnswer((_) async => const Right(null));
        when(
          mockLessonRepository.saveLessonProgress(testLessonId, testAccuracy),
        ).thenAnswer((_) async => const Right(null));
        return lessonBloc;
      },
      act: (bloc) => bloc.add(
        const LessonCompleteEvent(
          lessonId: testLessonId,
          accuracy: testAccuracy,
        ),
      ),
      expect: () => [const LessonState(status: LessonStatus.completed)],
      verify: (_) {
        // saveLessonProgressが呼ばれることを確認
        verify(
          mockLessonRepository.saveLessonProgress(testLessonId, testAccuracy),
        ).called(1);
      },
    );

    blocTest<LessonBloc, LessonState>(
      '複数のレッスン完了イベントを連続して処理できる',
      build: () {
        when(
          mockLessonRepository.saveLessonProgress(any, any),
        ).thenAnswer((_) async => const Right(null));
        return lessonBloc;
      },
      act: (bloc) async {
        bloc.add(
          const LessonCompleteEvent(lessonId: 'lesson_1_1', accuracy: 100),
        );
        await Future<void>.delayed(const Duration(milliseconds: 100));
        bloc.add(
          const LessonCompleteEvent(lessonId: 'lesson_1_2', accuracy: 90),
        );
        await Future<void>.delayed(const Duration(milliseconds: 100));
        bloc.add(
          const LessonCompleteEvent(lessonId: 'lesson_1_3', accuracy: 85),
        );
      },
      skip: 2, // 同じ状態が連続するのでスキップ
      verify: (_) {
        verify(
          mockLessonRepository.saveLessonProgress('lesson_1_1', 100),
        ).called(1);
        verify(
          mockLessonRepository.saveLessonProgress('lesson_1_2', 90),
        ).called(1);
        verify(
          mockLessonRepository.saveLessonProgress('lesson_1_3', 85),
        ).called(1);
      },
    );
  });

  group('LessonLoadAllEvent', () {
    final testLessons = <Lesson>[
      const Lesson(
        id: 'lesson_1_1',
        title: 'レッスン1',
        description: 'テスト',
        difficulty: LessonDifficulty.beginner,
        type: LessonType.noteRecognition,
        level: 1,
        order: 1,
        practiceNotes: [60],
        targetAccuracy: 80,
        isCompleted: false,
        isLocked: false,
      ),
      const Lesson(
        id: 'lesson_1_2',
        title: 'レッスン2',
        description: 'テスト',
        difficulty: LessonDifficulty.beginner,
        type: LessonType.noteRecognition,
        level: 1,
        order: 2,
        practiceNotes: [62],
        targetAccuracy: 80,
        isCompleted: false,
        isLocked: true,
      ),
    ];

    blocTest<LessonBloc, LessonState>(
      'レッスン一覧読み込みが成功する',
      build: () {
        when(mockGetLessons(any)).thenAnswer((_) async => Right(testLessons));
        return lessonBloc;
      },
      act: (bloc) => bloc.add(const LessonLoadAllEvent()),
      expect: () => [
        const LessonState(status: LessonStatus.loading),
        LessonState(status: LessonStatus.loaded, lessons: testLessons),
      ],
      verify: (_) {
        verify(mockGetLessons(const GetLessonsParams())).called(1);
      },
    );
  });
}
