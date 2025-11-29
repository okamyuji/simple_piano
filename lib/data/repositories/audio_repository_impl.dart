import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/audio_repository.dart';
import '../datasources/audio/audio_engine.dart';

/// オーディオリポジトリ実装
@LazySingleton(as: AudioRepository)
class AudioRepositoryImpl implements AudioRepository {
  final AudioEngine audioEngine;

  AudioRepositoryImpl(this.audioEngine);

  @override
  Future<Either<Failure, void>> playNote(
    Note note, {
    double volume = 1.0,
  }) async {
    try {
      await audioEngine.playNote(note, volume: volume);
      return const Right(null);
    } on AudioException catch (e) {
      return Left(AudioFailure(e.message));
    } catch (e) {
      return Left(AudioFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> stopNote(Note note) async {
    try {
      await audioEngine.stopNote(note);
      return const Right(null);
    } on AudioException catch (e) {
      return Left(AudioFailure(e.message));
    } catch (e) {
      return Left(AudioFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> stopAllNotes() async {
    try {
      await audioEngine.stopAllNotes();
      return const Right(null);
    } on AudioException catch (e) {
      return Left(AudioFailure(e.message));
    } catch (e) {
      return Left(AudioFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> initialize() async {
    try {
      await audioEngine.initialize();
      return const Right(null);
    } on AudioException catch (e) {
      return Left(AudioFailure(e.message));
    } catch (e) {
      return Left(AudioFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> dispose() async {
    try {
      await audioEngine.dispose();
      return const Right(null);
    } on AudioException catch (e) {
      return Left(AudioFailure(e.message));
    } catch (e) {
      return Left(AudioFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> setVolume(double volume) async {
    try {
      await audioEngine.setVolume(volume);
      return const Right(null);
    } on AudioException catch (e) {
      return Left(AudioFailure(e.message));
    } catch (e) {
      return Left(AudioFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> getVolume() async {
    try {
      final volume = audioEngine.getVolume();
      return Right(volume);
    } on AudioException catch (e) {
      return Left(AudioFailure(e.message));
    } catch (e) {
      return Left(AudioFailure('予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> preloadOctaveRange(
    int startOctave,
    int numberOfOctaves,
  ) async {
    try {
      await audioEngine.preloadOctaveRange(startOctave, numberOfOctaves);
      return const Right(null);
    } on AudioException catch (e) {
      return Left(AudioFailure(e.message));
    } catch (e) {
      return Left(AudioFailure('予期しないエラーが発生しました: $e'));
    }
  }
}
