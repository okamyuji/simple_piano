import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/practice_session.dart';
import '../repositories/progress_repository.dart';

/// セッション記録ユースケース
@injectable
class RecordSession implements UseCase<void, RecordSessionParams> {
  final ProgressRepository repository;

  RecordSession(this.repository);

  @override
  Future<Either<Failure, void>> call(RecordSessionParams params) async {
    return await repository.savePracticeSession(params.session);
  }
}

/// セッション記録パラメータ
class RecordSessionParams extends Equatable {
  final PracticeSession session;

  const RecordSessionParams({required this.session});

  @override
  List<Object?> get props => [session];
}
