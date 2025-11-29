import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/user_progress.dart';
import '../repositories/progress_repository.dart';

/// 進捗保存ユースケース
@injectable
class SaveProgress implements UseCase<void, SaveProgressParams> {
  final ProgressRepository repository;

  SaveProgress(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveProgressParams params) async {
    return await repository.saveUserProgress(params.progress);
  }
}

/// 進捗保存パラメータ
class SaveProgressParams extends Equatable {
  final UserProgress progress;

  const SaveProgressParams({required this.progress});

  @override
  List<Object?> get props => [progress];
}
