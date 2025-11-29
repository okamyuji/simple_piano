import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/recording.dart';
import '../repositories/recording_repository.dart';

/// 録音停止ユースケース
@injectable
class StopRecording implements UseCase<Recording, StopRecordingParams> {
  final RecordingRepository repository;

  StopRecording(this.repository);

  @override
  Future<Either<Failure, Recording>> call(StopRecordingParams params) async {
    return await repository.stopRecording(params.recordingId, params.name);
  }
}

/// 録音停止パラメータ
class StopRecordingParams extends Equatable {
  final String recordingId;
  final String name;

  const StopRecordingParams({required this.recordingId, required this.name});

  @override
  List<Object?> get props => [recordingId, name];
}
