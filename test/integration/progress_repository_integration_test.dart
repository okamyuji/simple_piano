import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_piano/data/datasources/local/database_helper.dart';
import 'package:simple_piano/data/datasources/local/local_storage_datasource.dart';
import 'package:simple_piano/data/repositories/progress_repository_impl.dart';
import 'package:simple_piano/domain/entities/practice_session.dart';
import 'package:simple_piano/domain/entities/user_progress.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // sqflite_ffiを初期化
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseHelper databaseHelper;
  late LocalStorageDataSource localStorageDataSource;
  late ProgressRepositoryImpl repository;

  setUp(() async {
    // SharedPreferencesをモックで初期化
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // テスト用のインメモリデータベースを使用
    databaseHelper = DatabaseHelper();
    localStorageDataSource = LocalStorageDataSource(prefs);
    repository = ProgressRepositoryImpl(localStorageDataSource, databaseHelper);

    // データベースを初期化
    await databaseHelper.database;
  });

  tearDown(() async {
    // データベースを削除
    try {
      await databaseHelper.deleteDatabase();
    } catch (e) {
      // ignore
    }
  });

  group('ProgressRepository 統合テスト', () {
    test('セッションを保存して取得できる', () async {
      // Arrange
      final now = DateTime.now();
      final session = PracticeSession(
        id: 'test_session_1',
        startTime: now.subtract(const Duration(minutes: 5)),
        endTime: now,
        duration: 300,
        notesPlayed: 50,
        lessonId: 'lesson_1_1',
        correctNotes: 45,
        accuracy: 90.0,
      );

      // Act - 保存
      final saveResult = await repository.savePracticeSession(session);

      // Assert - 保存成功
      expect(saveResult.isRight(), true);

      // Act - 取得
      final getResult = await repository.getPracticeSessions();

      // Assert - 取得成功
      getResult.fold((failure) => fail('取得に失敗: ${failure.message}'), (
        sessions,
      ) {
        expect(sessions.length, 1);
        expect(sessions.first.id, 'test_session_1');
        expect(sessions.first.duration, 300);
        expect(sessions.first.notesPlayed, 50);
        expect(sessions.first.lessonId, 'lesson_1_1');
      });
    });

    test('複数のセッションを保存して取得できる', () async {
      // Arrange
      final now = DateTime.now();
      final sessions = [
        PracticeSession(
          id: 'session_1',
          startTime: now.subtract(const Duration(hours: 2)),
          endTime: now.subtract(const Duration(hours: 1, minutes: 55)),
          duration: 300,
          notesPlayed: 50,
          lessonId: 'lesson_1_1',
        ),
        PracticeSession(
          id: 'session_2',
          startTime: now.subtract(const Duration(hours: 1)),
          endTime: now.subtract(const Duration(minutes: 55)),
          duration: 300,
          notesPlayed: 60,
          lessonId: 'lesson_1_2',
        ),
        PracticeSession(
          id: 'session_3',
          startTime: now.subtract(const Duration(minutes: 10)),
          endTime: now.subtract(const Duration(minutes: 5)),
          duration: 300,
          notesPlayed: 70,
          lessonId: 'lesson_2_1',
        ),
      ];

      // Act - すべて保存
      for (final session in sessions) {
        final result = await repository.savePracticeSession(session);
        expect(result.isRight(), true);
      }

      // Act - 取得
      final getResult = await repository.getPracticeSessions();

      // Assert
      expect(getResult.isRight(), true);
      getResult.fold((failure) => fail('取得に失敗: ${failure.message}'), (
        retrievedSessions,
      ) {
        expect(retrievedSessions.length, 3);
        // 最新順にソートされているか確認
        expect(retrievedSessions[0].id, 'session_3');
        expect(retrievedSessions[1].id, 'session_2');
        expect(retrievedSessions[2].id, 'session_1');
      });
    });

    test('UserProgressを保存して取得できる', () async {
      // Arrange
      final now = DateTime.now();
      final progress = UserProgress(
        userId: 'test_user',
        totalPracticeTime: 600,
        totalNotesPlayed: 120,
        currentStreak: 3,
        longestStreak: 5,
        completedLessons: const ['lesson_1_1', 'lesson_1_2'],
        achievedMilestones: const ['first_lesson'],
        createdAt: now,
        updatedAt: now,
      );

      // Act - 保存
      final saveResult = await repository.saveUserProgress(progress);

      // Assert - 保存成功
      expect(saveResult.isRight(), true);

      // Act - 取得
      final getResult = await repository.getUserProgress();

      // Assert - 取得成功
      expect(getResult.isRight(), true);
      getResult.fold((failure) => fail('取得に失敗: ${failure.message}'), (
        retrievedProgress,
      ) {
        expect(retrievedProgress.userId, 'test_user');
        expect(retrievedProgress.totalPracticeTime, 600);
        expect(retrievedProgress.totalNotesPlayed, 120);
        expect(retrievedProgress.currentStreak, 3);
        expect(retrievedProgress.longestStreak, 5);
        expect(retrievedProgress.completedLessons.length, 2);
        expect(retrievedProgress.completedLessons, contains('lesson_1_1'));
        expect(retrievedProgress.completedLessons, contains('lesson_1_2'));
      });
    });

    test('セッション保存後にUserProgressが更新される（実際のフロー）', () async {
      // Arrange - 初期進捗を作成
      final now = DateTime.now();
      var progress = UserProgress(
        userId: 'test_user',
        totalPracticeTime: 0,
        totalNotesPlayed: 0,
        createdAt: now,
        updatedAt: now,
      );

      await repository.saveUserProgress(progress);

      // Act - セッション1を保存
      final session1 = PracticeSession(
        id: 'session_1',
        startTime: now.subtract(const Duration(minutes: 5)),
        endTime: now,
        duration: 300,
        notesPlayed: 50,
        lessonId: 'lesson_1_1',
      );

      final saveSession1Result = await repository.savePracticeSession(session1);
      expect(saveSession1Result.isRight(), true);

      // 進捗を更新
      progress = progress.copyWith(
        totalPracticeTime: progress.totalPracticeTime + session1.duration,
        totalNotesPlayed: progress.totalNotesPlayed + session1.notesPlayed,
        updatedAt: DateTime.now(),
      );
      await repository.saveUserProgress(progress);

      // Act - セッション2を保存
      final session2 = PracticeSession(
        id: 'session_2',
        startTime: now,
        endTime: now.add(const Duration(minutes: 5)),
        duration: 300,
        notesPlayed: 60,
        lessonId: 'lesson_1_2',
      );

      final saveSession2Result = await repository.savePracticeSession(session2);
      expect(saveSession2Result.isRight(), true);

      // 進捗を更新
      progress = progress.copyWith(
        totalPracticeTime: progress.totalPracticeTime + session2.duration,
        totalNotesPlayed: progress.totalNotesPlayed + session2.notesPlayed,
        updatedAt: DateTime.now(),
      );
      await repository.saveUserProgress(progress);

      // Assert - 最終的な進捗を確認
      final getProgressResult = await repository.getUserProgress();
      expect(getProgressResult.isRight(), true);
      getProgressResult.fold((failure) => fail('進捗取得に失敗: ${failure.message}'), (
        finalProgress,
      ) {
        expect(finalProgress.totalPracticeTime, 600); // 300 + 300
        expect(finalProgress.totalNotesPlayed, 110); // 50 + 60
      });

      // Assert - セッションも確認
      final getSessionsResult = await repository.getPracticeSessions();
      expect(getSessionsResult.isRight(), true);
      getSessionsResult.fold(
        (failure) => fail('セッション取得に失敗: ${failure.message}'),
        (sessions) {
          expect(sessions.length, 2);
        },
      );
    });

    test('統計情報を取得できる', () async {
      // Arrange - 進捗とセッションを作成
      final now = DateTime.now();
      final progress = UserProgress(
        userId: 'test_user',
        totalPracticeTime: 600,
        totalNotesPlayed: 110,
        currentStreak: 2,
        longestStreak: 5,
        completedLessons: const ['lesson_1_1', 'lesson_1_2'],
        createdAt: now,
        updatedAt: now,
      );

      await repository.saveUserProgress(progress);

      final sessions = [
        PracticeSession(
          id: 'session_1',
          startTime: now.subtract(const Duration(hours: 1)),
          endTime: now.subtract(const Duration(minutes: 55)),
          duration: 300,
          notesPlayed: 50,
          lessonId: 'lesson_1_1',
        ),
        PracticeSession(
          id: 'session_2',
          startTime: now.subtract(const Duration(minutes: 10)),
          endTime: now.subtract(const Duration(minutes: 5)),
          duration: 300,
          notesPlayed: 60,
          lessonId: 'lesson_1_2',
        ),
      ];

      for (final session in sessions) {
        await repository.savePracticeSession(session);
      }

      // Act - 統計を取得
      final statsResult = await repository.getStatistics();

      // Assert
      expect(statsResult.isRight(), true);
      statsResult.fold((failure) => fail('統計取得に失敗: ${failure.message}'), (
        stats,
      ) {
        expect(stats['totalPracticeTime'], 600);
        expect(stats['totalNotesPlayed'], 110);
        expect(stats['currentStreak'], 2);
        expect(stats['longestStreak'], 5);
        expect(stats['completedLessons'], 2);
        expect(stats['totalSessions'], 2);
        expect(stats['averageSessionDuration'], 300);
      });
    });
  });
}
