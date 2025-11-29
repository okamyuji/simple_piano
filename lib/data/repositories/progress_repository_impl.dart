import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart' as app_exceptions;
import '../../core/errors/failures.dart';
import '../../domain/entities/daily_challenge.dart';
import '../../domain/entities/practice_session.dart';
import '../../domain/entities/user_progress.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/local/database_helper.dart';
import '../datasources/local/local_storage_datasource.dart';
import '../models/daily_challenge_model.dart';
import '../models/user_progress_model.dart';

/// 進捗リポジトリ実装
@LazySingleton(as: ProgressRepository)
class ProgressRepositoryImpl implements ProgressRepository {
  final LocalStorageDataSource localStorageDataSource;
  final DatabaseHelper databaseHelper;

  ProgressRepositoryImpl(this.localStorageDataSource, this.databaseHelper);

  @override
  Future<Either<Failure, UserProgress>> getUserProgress() async {
    try {
      final json = localStorageDataSource.getJson(AppConstants.keyUserProgress);
      if (json == null) {
        // 初回起動時は新規作成
        final now = DateTime.now();
        final progress = UserProgress(
          userId: 'default_user',
          createdAt: now,
          updatedAt: now,
        );
        await saveUserProgress(progress);
        return Right(progress);
      }
      final model = UserProgressModel.fromJson(json);
      return Right(model.toEntity());
    } on app_exceptions.CacheException {
      return Left(CacheFailure('キャッシュの読み込みに失敗しました'));
    } catch (e) {
      return Left(CacheFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveUserProgress(UserProgress progress) async {
    try {
      debugPrint(
        '[ProgressRepository] UserProgress保存: 練習時間=${progress.totalPracticeTime}秒, 音符数=${progress.totalNotesPlayed}',
      );
      final model = UserProgressModel.fromEntity(progress);
      final json = model.toJson();
      debugPrint('[ProgressRepository] JSON: $json');
      await localStorageDataSource.saveJson(AppConstants.keyUserProgress, json);
      debugPrint('[ProgressRepository] UserProgress保存完了');
      return const Right(null);
    } on app_exceptions.CacheException catch (e) {
      debugPrint('[ProgressRepository] CacheException: $e');
      return Left(CacheFailure('キャッシュの保存に失敗しました'));
    } catch (e) {
      debugPrint('[ProgressRepository] Exception: $e');
      return Left(CacheFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> savePracticeSession(
    PracticeSession session,
  ) async {
    try {
      final db = await databaseHelper.database;

      // データベース用のマップを直接作成
      final map = <String, dynamic>{
        'id': session.id,
        'lesson_id': session.lessonId,
        'start_time': session.startTime.millisecondsSinceEpoch,
        'end_time': session.endTime?.millisecondsSinceEpoch,
        'duration': session.duration,
        'notes_played': session.notesPlayed,
        'correct_notes': session.correctNotes,
        'accuracy': session.accuracy,
        'recording_path': session.recordingPath,
        'notes': session.notes,
      };

      await db.insert(
        'practice_sessions',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return const Right(null);
    } on DatabaseException catch (e) {
      debugPrint('[ProgressRepository] DatabaseException: $e');
      return Left(DatabaseFailure('データベースエラーが発生しました: $e'));
    } catch (e) {
      debugPrint('[ProgressRepository] Exception: $e');
      return Left(DatabaseFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PracticeSession>>> getPracticeSessions({
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      debugPrint('[ProgressRepository] セッション取得開始');
      final db = await databaseHelper.database;

      String whereClause = '';
      List<dynamic> whereArgs = [];

      if (startDate != null) {
        whereClause += 'start_time >= ?';
        whereArgs.add(startDate.millisecondsSinceEpoch);
      }

      if (endDate != null) {
        if (whereClause.isNotEmpty) whereClause += ' AND ';
        whereClause += 'start_time <= ?';
        whereArgs.add(endDate.millisecondsSinceEpoch);
      }

      final maps = await db.query(
        'practice_sessions',
        where: whereClause.isEmpty ? null : whereClause,
        whereArgs: whereArgs.isEmpty ? null : whereArgs,
        orderBy: 'start_time DESC',
        limit: limit,
      );

      debugPrint('[ProgressRepository] 取得したセッション数: ${maps.length}');

      final sessions = maps.map((map) {
        // データベースから直接エンティティを作成（ModelのfromJsonは使わない）
        return PracticeSession(
          id: map['id'] as String,
          lessonId: map['lesson_id'] as String?,
          startTime: DateTime.fromMillisecondsSinceEpoch(
            map['start_time'] as int,
          ),
          endTime: map['end_time'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['end_time'] as int)
              : null,
          duration: map['duration'] as int? ?? 0,
          notesPlayed: map['notes_played'] as int? ?? 0,
          correctNotes: map['correct_notes'] as int?,
          accuracy: map['accuracy'] as double?,
          recordingPath: map['recording_path'] as String?,
          notes: map['notes'] as String?,
        );
      }).toList();

      return Right(sessions);
    } on app_exceptions.DatabaseException {
      return Left(DatabaseFailure('データベースエラーが発生しました'));
    } catch (e) {
      return Left(DatabaseFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, DailyChallenge>> getTodayChallenge() async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // 既存のチャレンジを確認
      final db = await databaseHelper.database;
      final maps = await db.query(
        'daily_challenges',
        where: 'date = ?',
        whereArgs: [today.millisecondsSinceEpoch],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        final model = DailyChallengeModel.fromJson({
          ...maps.first,
          'date': DateTime.fromMillisecondsSinceEpoch(
            maps.first['date'] as int,
          ),
        });
        return Right(model.toEntity());
      }

      // 新しいチャレンジを生成
      final challenge = _generateDailyChallenge(today);
      final model = DailyChallengeModel.fromEntity(challenge);
      final map = model.toJson();
      map['date'] = today.millisecondsSinceEpoch;

      await db.insert('daily_challenges', map);
      return Right(challenge);
    } on app_exceptions.DatabaseException {
      return Left(DatabaseFailure('データベースエラーが発生しました'));
    } catch (e) {
      return Left(DatabaseFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateChallengeProgress(
    String challengeId,
    int currentValue,
  ) async {
    try {
      final db = await databaseHelper.database;
      await db.update(
        'daily_challenges',
        {'current_value': currentValue},
        where: 'id = ?',
        whereArgs: [challengeId],
      );
      return const Right(null);
    } on app_exceptions.DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markChallengeComplete(
    String challengeId,
  ) async {
    try {
      final db = await databaseHelper.database;
      await db.update(
        'daily_challenges',
        {'is_completed': 1},
        where: 'id = ?',
        whereArgs: [challengeId],
      );
      return const Right(null);
    } on app_exceptions.DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateStreak() async {
    try {
      final progressResult = await getUserProgress();
      return progressResult.fold((failure) => Left(failure), (progress) async {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        int newStreak = progress.currentStreak;

        if (progress.lastPracticeDate != null) {
          final lastDate = DateTime(
            progress.lastPracticeDate!.year,
            progress.lastPracticeDate!.month,
            progress.lastPracticeDate!.day,
          );

          final difference = today.difference(lastDate).inDays;

          if (difference == 1) {
            // 連続日
            newStreak++;
          } else if (difference > 1) {
            // ストリーク途切れ
            newStreak = 1;
          }
          // difference == 0 の場合は同じ日なので変更なし
        } else {
          newStreak = 1;
        }

        final updatedProgress = progress.copyWith(
          currentStreak: newStreak,
          longestStreak: newStreak > progress.longestStreak
              ? newStreak
              : progress.longestStreak,
          lastPracticeDate: now,
          updatedAt: now,
        );

        return await saveUserProgress(updatedProgress);
      });
    } catch (e) {
      return Left(CacheFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addMilestone(String milestone) async {
    try {
      final progressResult = await getUserProgress();
      return progressResult.fold((failure) => Left(failure), (progress) async {
        if (!progress.achievedMilestones.contains(milestone)) {
          final updatedMilestones = [...progress.achievedMilestones, milestone];
          final updatedProgress = progress.copyWith(
            achievedMilestones: updatedMilestones,
            updatedAt: DateTime.now(),
          );
          return await saveUserProgress(updatedProgress);
        }
        return const Right(null);
      });
    } catch (e) {
      return Left(CacheFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getStatistics() async {
    try {
      final progressResult = await getUserProgress();
      return progressResult.fold((failure) => Left(failure), (progress) async {
        final sessionsResult = await getPracticeSessions();
        return sessionsResult.fold((failure) => Left(failure), (sessions) {
          final stats = <String, dynamic>{
            'totalPracticeTime': progress.totalPracticeTime,
            'currentStreak': progress.currentStreak,
            'longestStreak': progress.longestStreak,
            'completedLessons': progress.completedLessons.length,
            'totalNotesPlayed': progress.totalNotesPlayed,
            'totalSessions': sessions.length,
            'averageSessionDuration': sessions.isEmpty
                ? 0
                : sessions.map((s) => s.duration).reduce((a, b) => a + b) ~/
                      sessions.length,
          };
          return Right(stats);
        });
      });
    } catch (e) {
      return Left(CacheFailure('予期しないエラーが発生しました: $e'));
    }
  }

  /// デイリーチャレンジを生成
  DailyChallenge _generateDailyChallenge(DateTime date) {
    // 日付に基づいてランダムなチャレンジを生成
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final challengeType =
        ChallengeType.values[dayOfYear % ChallengeType.values.length];

    String title;
    String description;
    int targetValue;

    switch (challengeType) {
      case ChallengeType.practiceTime:
        title = '5分間練習しよう';
        description = '今日は5分間ピアノを練習しましょう';
        targetValue = 300; // 秒
        break;
      case ChallengeType.noteCount:
        title = '50音弾こう';
        description = '今日は50個の音符を弾きましょう';
        targetValue = 50;
        break;
      case ChallengeType.accuracy:
        title = '正解率80%を目指そう';
        description = 'レッスンで80%以上の正解率を達成しましょう';
        targetValue = 80;
        break;
      case ChallengeType.streak:
        title = '連続練習を続けよう';
        description = '今日も練習してストリークを伸ばしましょう';
        targetValue = 1;
        break;
      case ChallengeType.lessonCompletion:
        title = 'レッスンを1つ完了しよう';
        description = '今日は1つのレッスンを完了させましょう';
        targetValue = 1;
        break;
    }

    return DailyChallenge(
      id: 'challenge_${date.millisecondsSinceEpoch}',
      title: title,
      description: description,
      type: challengeType,
      targetValue: targetValue,
      date: date,
    );
  }
}
