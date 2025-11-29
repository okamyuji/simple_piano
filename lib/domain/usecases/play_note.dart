import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/note.dart';
import '../repositories/audio_repository.dart';

/// 音符再生ユースケース
@injectable
class PlayNote implements UseCase<void, PlayNoteParams> {
  final AudioRepository repository;

  PlayNote(this.repository);

  @override
  Future<Either<Failure, void>> call(PlayNoteParams params) async {
    return await repository.playNote(params.note, volume: params.volume);
  }
}

/// 音符再生パラメータ
class PlayNoteParams extends Equatable {
  final Note note;
  final double volume;

  const PlayNoteParams({required this.note, this.volume = 1.0});

  @override
  List<Object?> get props => [note, volume];
}
