import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_piano/core/errors/failures.dart';
import 'package:simple_piano/data/datasources/audio/audio_engine.dart';
import 'package:simple_piano/data/repositories/audio_repository_impl.dart';
import 'package:simple_piano/domain/entities/note.dart';

@GenerateMocks([AudioEngine])
import 'audio_repository_impl_test.mocks.dart';

void main() {
  late AudioRepositoryImpl repository;
  late MockAudioEngine mockAudioEngine;

  setUp(() {
    mockAudioEngine = MockAudioEngine();
    repository = AudioRepositoryImpl(mockAudioEngine);
  });

  const tNote = Note(
    midiNumber: 60,
    noteName: 'C4',
    octave: 4,
    frequency: 261.63,
    isWhiteKey: true,
  );

  group('playNote', () {
    test('should play note successfully', () async {
      // arrange
      when(
        mockAudioEngine.playNote(any, volume: anyNamed('volume')),
      ).thenAnswer((_) async {});

      // act
      final result = await repository.playNote(tNote);

      // assert
      expect(result, const Right(null));
      verify(mockAudioEngine.playNote(tNote, volume: 1.0));
    });

    test('should return AudioFailure when playback fails', () async {
      // arrange
      when(
        mockAudioEngine.playNote(any, volume: anyNamed('volume')),
      ).thenThrow(Exception('Failed'));

      // act
      final result = await repository.playNote(tNote);

      // assert
      expect(result, isA<Left>());
      expect((result as Left).value, isA<AudioFailure>());
    });
  });

  group('stopNote', () {
    test('should stop note successfully', () async {
      // arrange
      when(mockAudioEngine.stopNote(any)).thenAnswer((_) async {});

      // act
      final result = await repository.stopNote(tNote);

      // assert
      expect(result, const Right(null));
      verify(mockAudioEngine.stopNote(tNote));
    });

    test('should return AudioFailure when stop fails', () async {
      // arrange
      when(mockAudioEngine.stopNote(any)).thenThrow(Exception('Failed'));

      // act
      final result = await repository.stopNote(tNote);

      // assert
      expect(result, isA<Left>());
      expect((result as Left).value, isA<AudioFailure>());
    });
  });
}
