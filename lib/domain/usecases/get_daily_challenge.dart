import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/daily_challenge.dart';
import '../repositories/progress_repository.dart';

/// デイリーチャレンジ取得ユースケース
@injectable
class GetDailyChallenge implements UseCaseNoParams<DailyChallenge> {
  final ProgressRepository repository;

  GetDailyChallenge(this.repository);

  @override
  Future<Either<Failure, DailyChallenge>> call() async {
    return await repository.getTodayChallenge();
  }
}
