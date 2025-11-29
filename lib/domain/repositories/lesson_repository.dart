import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/lesson.dart';

/// レッスンリポジトリインターフェース
abstract class LessonRepository {
  /// すべてのレッスンを取得
  Future<Either<Failure, List<Lesson>>> getAllLessons();

  /// レベル別にレッスンを取得
  Future<Either<Failure, List<Lesson>>> getLessonsByLevel(int level);

  /// IDでレッスンを取得
  Future<Either<Failure, Lesson>> getLessonById(String id);

  /// レッスンを完了としてマーク
  Future<Either<Failure, void>> markLessonComplete(String lessonId);

  /// レッスンの進捗を保存
  Future<Either<Failure, void>> saveLessonProgress(
    String lessonId,
    int accuracy,
  );

  /// 次のレッスンを取得
  Future<Either<Failure, Lesson?>> getNextLesson(String currentLessonId);

  /// 完了したレッスンのIDリストを取得
  Future<Either<Failure, List<String>>> getCompletedLessonIds();
}
