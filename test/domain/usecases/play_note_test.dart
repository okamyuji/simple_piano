import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_piano/core/errors/failures.dart';
import 'package:simple_piano/domain/entities/note.dart';
import 'package:simple_piano/domain/repositories/audio_repository.dart';
import 'package:simple_piano/domain/usecases/play_note.dart';

@GenerateMocks([AudioRepository])
import 'play_note_test.mocks.dart';

void main() {
  late PlayNote usecase;
  late MockAudioRepository mockAudioRepository;

  setUp(() {
    mockAudioRepository = MockAudioRepository();
    usecase = PlayNote(mockAudioRepository);
  });

  const tNote = Note(
    midiNumber: 60,
    noteName: 'C4',
    octave: 4,
    frequency: 261.63,
    isWhiteKey: true,
  );

  test('should play note successfully', () async {
    // arrange
    when(
      mockAudioRepository.playNote(any, volume: anyNamed('volume')),
    ).thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(const PlayNoteParams(note: tNote));

    // assert
    expect(result, const Right(null));
    verify(mockAudioRepository.playNote(tNote, volume: 1.0));
    verifyNoMoreInteractions(mockAudioRepository);
  });

  test('should return failure when audio playback fails', () async {
    // arrange
    when(
      mockAudioRepository.playNote(any, volume: anyNamed('volume')),
    ).thenAnswer((_) async => Left(AudioFailure()));

    // act
    final result = await usecase(const PlayNoteParams(note: tNote));

    // assert
    expect(result, Left(AudioFailure()));
    verify(mockAudioRepository.playNote(tNote, volume: 1.0));
    verifyNoMoreInteractions(mockAudioRepository);
  });
}
