import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_piano/core/errors/failures.dart';
import 'package:simple_piano/data/services/lesson_data_service.dart';
import 'package:simple_piano/data/repositories/lesson_repository_impl.dart';
import 'package:simple_piano/domain/entities/user_progress.dart';
import 'package:simple_piano/domain/repositories/progress_repository.dart';

class _ThrowingSaveProgressRepository implements ProgressRepository {
  final DateTime now = DateTime(2026, 1, 1);

  @override
  Future<Either<Failure, UserProgress>> getUserProgress() async =>
      Right(UserProgress(userId: 'u', createdAt: now, updatedAt: now));

  @override
  Future<Either<Failure, void>> saveUserProgress(UserProgress progress) =>
      Future.error(StateError('disk full'));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedLessonDataService implements LessonDataService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'markLessonComplete returns a Left when saving the progress throws',
    () async {
      final repository = LessonRepositoryImpl(
        _UnusedLessonDataService(),
        _ThrowingSaveProgressRepository(),
      );

      final result = await repository.markLessonComplete('lesson-1');

      expect(result.isLeft(), isTrue);
    },
  );
}
