import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/lesson.dart';
import '../repositories/lesson_repository.dart';

/// レッスン取得ユースケース
@injectable
class GetLessons implements UseCase<List<Lesson>, GetLessonsParams> {
  final LessonRepository repository;

  GetLessons(this.repository);

  @override
  Future<Either<Failure, List<Lesson>>> call(GetLessonsParams params) async {
    if (params.level != null) {
      return await repository.getLessonsByLevel(params.level!);
    }
    return await repository.getAllLessons();
  }
}

/// レッスン取得パラメータ
class GetLessonsParams extends Equatable {
  final int? level;

  const GetLessonsParams({this.level});

  @override
  List<Object?> get props => [level];
}
