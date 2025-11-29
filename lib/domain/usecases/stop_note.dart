import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/note.dart';
import '../repositories/audio_repository.dart';

/// 音符停止ユースケース
@injectable
class StopNote implements UseCase<void, StopNoteParams> {
  final AudioRepository repository;

  StopNote(this.repository);

  @override
  Future<Either<Failure, void>> call(StopNoteParams params) async {
    return await repository.stopNote(params.note);
  }
}

/// 音符停止パラメータ
class StopNoteParams extends Equatable {
  final Note note;

  const StopNoteParams({required this.note});

  @override
  List<Object?> get props => [note];
}
