import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_piano/core/errors/failures.dart';
import 'package:simple_piano/domain/entities/practice_session.dart';
import 'package:simple_piano/domain/entities/user_progress.dart';
import 'package:simple_piano/domain/repositories/progress_repository.dart';
import 'package:simple_piano/domain/usecases/get_daily_challenge.dart';
import 'package:simple_piano/domain/usecases/get_user_progress.dart';
import 'package:simple_piano/domain/usecases/record_session.dart';
import 'package:simple_piano/domain/usecases/save_progress.dart';
import 'package:simple_piano/presentation/bloc/progress/progress_bloc.dart';
import 'package:simple_piano/presentation/bloc/progress/progress_event.dart';
import 'package:simple_piano/presentation/bloc/progress/progress_state.dart';

import 'progress_bloc_session_test.mocks.dart';

@GenerateMocks([
  GetUserProgress,
  SaveProgress,
  RecordSession,
  GetDailyChallenge,
  ProgressRepository,
])
void main() {
  late MockGetUserProgress mockGetUserProgress;
  late MockSaveProgress mockSaveProgress;
  late MockRecordSession mockRecordSession;
  late MockGetDailyChallenge mockGetDailyChallenge;
  late MockProgressRepository mockProgressRepository;
  late ProgressBloc progressBloc;

  setUp(() {
    mockGetUserProgress = MockGetUserProgress();
    mockSaveProgress = MockSaveProgress();
    mockRecordSession = MockRecordSession();
    mockGetDailyChallenge = MockGetDailyChallenge();
    mockProgressRepository = MockProgressRepository();

    progressBloc = ProgressBloc(
      getUserProgressUseCase: mockGetUserProgress,
      saveProgressUseCase: mockSaveProgress,
      recordSessionUseCase: mockRecordSession,
      getDailyChallengeUseCase: mockGetDailyChallenge,
      progressRepository: mockProgressRepository,
    );
  });

  tearDown(() {
    progressBloc.close();
  });

  group('ProgressBloc セッション記録テスト', () {
    final now = DateTime.now();
    final session = PracticeSession(
      id: 'test_session',
      startTime: now.subtract(const Duration(minutes: 5)),
      endTime: now,
      duration: 300, // 5分
      notesPlayed: 100,
      lessonId: 'lesson_1_1',
    );

    final userProgress = UserProgress(
      userId: 'test_user',
      totalPracticeTime: 0,
      totalNotesPlayed: 0,
      createdAt: now,
      updatedAt: now,
    );

    blocTest<ProgressBloc, ProgressState>(
      'セッション保存が成功すると進捗が更新される',
      build: () {
        when(mockRecordSession(any)).thenAnswer((_) async => const Right(null));
        when(mockSaveProgress(any)).thenAnswer((_) async => const Right(null));
        return progressBloc;
      },
      seed: () => ProgressState(userProgress: userProgress),
      act: (bloc) => bloc.add(ProgressSaveSessionEvent(session: session)),
      expect: () => [
        ProgressState(
          userProgress: userProgress,
          status: ProgressStatus.saving,
        ),
        isA<ProgressState>()
            .having((s) => s.status, 'status', ProgressStatus.saved)
            .having(
              (s) => s.userProgress?.totalPracticeTime,
              'totalPracticeTime',
              300,
            )
            .having(
              (s) => s.userProgress?.totalNotesPlayed,
              'totalNotesPlayed',
              100,
            ),
      ],
      verify: (_) {
        verify(mockRecordSession(any)).called(1);
        verify(mockSaveProgress(any)).called(1);
      },
    );

    blocTest<ProgressBloc, ProgressState>(
      'UserProgressがnullの場合は再読み込みする',
      build: () {
        when(mockRecordSession(any)).thenAnswer((_) async => const Right(null));
        when(
          mockGetUserProgress(),
        ).thenAnswer((_) async => Right(userProgress));
        when(mockSaveProgress(any)).thenAnswer((_) async => const Right(null));
        return progressBloc;
      },
      seed: () => const ProgressState(),
      act: (bloc) => bloc.add(ProgressSaveSessionEvent(session: session)),
      expect: () => [
        const ProgressState(status: ProgressStatus.saving),
        isA<ProgressState>()
            .having((s) => s.status, 'status', ProgressStatus.saved)
            .having(
              (s) => s.userProgress?.totalPracticeTime,
              'totalPracticeTime',
              300,
            )
            .having(
              (s) => s.userProgress?.totalNotesPlayed,
              'totalNotesPlayed',
              100,
            ),
      ],
      verify: (_) {
        verify(mockRecordSession(any)).called(1);
        verify(mockGetUserProgress()).called(1);
        verify(mockSaveProgress(any)).called(1);
      },
    );

    blocTest<ProgressBloc, ProgressState>(
      'セッション保存が失敗するとエラー状態になる',
      build: () {
        when(
          mockRecordSession(any),
        ).thenAnswer((_) async => const Left(DatabaseFailure('保存エラー')));
        return progressBloc;
      },
      seed: () => ProgressState(userProgress: userProgress),
      act: (bloc) => bloc.add(ProgressSaveSessionEvent(session: session)),
      expect: () => [
        ProgressState(
          userProgress: userProgress,
          status: ProgressStatus.saving,
        ),
        ProgressState(
          userProgress: userProgress,
          status: ProgressStatus.error,
          errorMessage: '保存エラー',
        ),
      ],
      verify: (_) {
        verify(mockRecordSession(any)).called(1);
        verifyNever(mockSaveProgress(any));
      },
    );

    blocTest<ProgressBloc, ProgressState>(
      '複数セッションを保存すると累積される',
      build: () {
        when(mockRecordSession(any)).thenAnswer((_) async => const Right(null));
        when(mockSaveProgress(any)).thenAnswer((_) async => const Right(null));
        return progressBloc;
      },
      seed: () => ProgressState(
        userProgress: userProgress.copyWith(
          totalPracticeTime: 300,
          totalNotesPlayed: 100,
        ),
      ),
      act: (bloc) => bloc.add(ProgressSaveSessionEvent(session: session)),
      expect: () => [
        ProgressState(
          userProgress: userProgress.copyWith(
            totalPracticeTime: 300,
            totalNotesPlayed: 100,
          ),
          status: ProgressStatus.saving,
        ),
        isA<ProgressState>()
            .having((s) => s.status, 'status', ProgressStatus.saved)
            .having(
              (s) => s.userProgress?.totalPracticeTime,
              'totalPracticeTime',
              600,
            )
            .having(
              (s) => s.userProgress?.totalNotesPlayed,
              'totalNotesPlayed',
              200,
            ),
      ],
    );
  });
}
