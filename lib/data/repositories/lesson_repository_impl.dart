import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../services/lesson_data_service.dart';

/// レッスンリポジトリ実装
@LazySingleton(as: LessonRepository)
class LessonRepositoryImpl implements LessonRepository {
  final LessonDataService lessonDataService;
  final ProgressRepository progressRepository;

  LessonRepositoryImpl(this.lessonDataService, this.progressRepository);

  @override
  Future<Either<Failure, List<Lesson>>> getAllLessons() async {
    try {
      final lessons = lessonDataService.getAllLessons();
      final completedLessonIdsResult = await _getCompletedLessonIds();

      return completedLessonIdsResult.fold((failure) => Left(failure), (
        completedLessonIds,
      ) {
        debugPrint('[LessonRepository] 完了済みレッスンID: $completedLessonIds');

        // 完了状態を反映
        final updatedLessons = lessons.map((lesson) {
          final isCompleted = completedLessonIds.contains(lesson.id);
          final isLocked = _isLessonLocked(lesson, completedLessonIds);
          debugPrint(
            '[LessonRepository] ${lesson.id} (order=${lesson.order}): '
            'completed=$isCompleted, locked=$isLocked',
          );
          return lesson.copyWith(isCompleted: isCompleted, isLocked: isLocked);
        }).toList();

        return Right(updatedLessons);
      });
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Lesson>>> getLessonsByLevel(int level) async {
    try {
      final allLessonsResult = await getAllLessons();
      return allLessonsResult.fold((failure) => Left(failure), (lessons) {
        final filteredLessons = lessons
            .where((lesson) => lesson.level == level)
            .toList();
        return Right(filteredLessons);
      });
    } catch (e) {
      return Left(CacheFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, Lesson>> getLessonById(String id) async {
    try {
      final allLessonsResult = await getAllLessons();
      return allLessonsResult.fold((failure) => Left(failure), (lessons) {
        try {
          final lesson = lessons.firstWhere((l) => l.id == id);
          return Right(lesson);
        } catch (e) {
          return const Left(CacheFailure('レッスンが見つかりません'));
        }
      });
    } catch (e) {
      return Left(CacheFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markLessonComplete(String lessonId) async {
    try {
      // UserProgressを取得
      final progressResult = await progressRepository.getUserProgress();
      return progressResult.fold(
        (failure) {
          debugPrint('[LessonRepository] UserProgress取得失敗: ${failure.message}');
          return Left(failure);
        },
        (progress) async {
          // 既に完了済みならスキップ
          if (progress.completedLessons.contains(lessonId)) {
            debugPrint('[LessonRepository] 既に完了済み: $lessonId');
            debugPrint(
              '[LessonRepository] 完了済みレッスン: ${progress.completedLessons}',
            );
            return const Right(null);
          }

          // completedLessonsに追加
          final updatedProgress = progress.copyWith(
            completedLessons: [...progress.completedLessons, lessonId],
            updatedAt: DateTime.now(),
          );

          // 保存
          debugPrint('[LessonRepository] レッスン完了を記録: $lessonId');
          debugPrint(
            '[LessonRepository] 更新後の完了済みレッスン: ${updatedProgress.completedLessons}',
          );
          final saveResult = await progressRepository.saveUserProgress(
            updatedProgress,
          );
          return saveResult.fold(
            (failure) {
              debugPrint('[LessonRepository] 保存失敗: ${failure.message}');
              return Left(failure);
            },
            (success) {
              debugPrint('[LessonRepository] 保存成功: $lessonId');
              return const Right(null);
            },
          );
        },
      );
    } catch (e) {
      debugPrint('[LessonRepository] 例外発生: $e');
      return Left(CacheFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveLessonProgress(
    String lessonId,
    int accuracy,
  ) async {
    try {
      // 目標達成率を超えたら完了とマーク
      final lessonResult = await getLessonById(lessonId);
      return lessonResult.fold(
        (failure) {
          debugPrint('[LessonRepository] レッスン取得失敗: ${failure.message}');
          return Left(failure);
        },
        (lesson) async {
          debugPrint(
            '[LessonRepository] 進捗保存: $lessonId, 精度: $accuracy%, 目標: ${lesson.targetAccuracy}%',
          );
          if (accuracy >= lesson.targetAccuracy) {
            final result = await markLessonComplete(lessonId);
            debugPrint('[LessonRepository] レッスン完了マーク: $lessonId, 結果: $result');
            return result;
          }
          debugPrint('[LessonRepository] 目標未達のため完了マークなし');
          return const Right(null);
        },
      );
    } catch (e) {
      debugPrint('[LessonRepository] 予期しないエラー: $e');
      return Left(CacheFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, Lesson?>> getNextLesson(String currentLessonId) async {
    try {
      final allLessonsResult = await getAllLessons();
      return allLessonsResult.fold((failure) => Left(failure), (lessons) {
        try {
          final currentLesson = lessons.firstWhere(
            (l) => l.id == currentLessonId,
          );
          final nextLessons = lessons
              .where((l) => l.order == currentLesson.order + 1)
              .toList();
          if (nextLessons.isEmpty) {
            return const Right(null);
          }
          return Right(nextLessons.first);
        } catch (e) {
          return const Right(null);
        }
      });
    } catch (e) {
      return Left(CacheFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCompletedLessonIds() async {
    return _getCompletedLessonIds();
  }

  /// 完了したレッスンIDを取得（内部用）
  Future<Either<Failure, List<String>>> _getCompletedLessonIds() async {
    final progressResult = await progressRepository.getUserProgress();
    return progressResult.fold(
      (failure) => Left(failure),
      (progress) => Right(progress.completedLessons),
    );
  }

  /// レッスンがロックされているか判定
  bool _isLessonLocked(Lesson lesson, List<String> completedLessonIds) {
    // 最初のレッスンはロックしない
    if (lesson.order == 1) return false;

    // 前のレッスンが完了していない場合はロック
    final allLessons = lessonDataService.getAllLessons();
    final previousLesson = allLessons
        .where((l) => l.order == lesson.order - 1)
        .firstOrNull;

    if (previousLesson == null) return false;

    return !completedLessonIds.contains(previousLesson.id);
  }
}

/// リストの拡張メソッド
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
