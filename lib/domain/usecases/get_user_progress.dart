import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/user_progress.dart';
import '../repositories/progress_repository.dart';

/// ユーザー進捗取得ユースケース
@injectable
class GetUserProgress implements UseCaseNoParams<UserProgress> {
  final ProgressRepository repository;

  GetUserProgress(this.repository);

  @override
  Future<Either<Failure, UserProgress>> call() async {
    return await repository.getUserProgress();
  }
}
