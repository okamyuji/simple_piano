import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/recording_repository.dart';

/// 録音開始ユースケース
@injectable
class StartRecording implements UseCaseNoParams<String> {
  final RecordingRepository repository;

  StartRecording(this.repository);

  @override
  Future<Either<Failure, String>> call() async {
    return await repository.startRecording();
  }
}
