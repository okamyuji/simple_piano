import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_piano/core/errors/failures.dart';
import 'package:simple_piano/domain/entities/note.dart';
import 'package:simple_piano/domain/repositories/audio_repository.dart';
import 'package:simple_piano/domain/usecases/stop_note.dart';

@GenerateMocks([AudioRepository])
import 'play_note_test.mocks.dart';

void main() {
  late StopNote usecase;
  late MockAudioRepository mockAudioRepository;

  setUp(() {
    mockAudioRepository = MockAudioRepository();
    usecase = StopNote(mockAudioRepository);
  });

  const tNote = Note(
    midiNumber: 60,
    noteName: 'C4',
    octave: 4,
    frequency: 261.63,
    isWhiteKey: true,
  );

  test('should stop note successfully', () async {
    // arrange
    when(
      mockAudioRepository.stopNote(any),
    ).thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(const StopNoteParams(note: tNote));

    // assert
    expect(result, const Right(null));
    verify(mockAudioRepository.stopNote(tNote));
    verifyNoMoreInteractions(mockAudioRepository);
  });

  test('should return failure when stopping note fails', () async {
    // arrange
    when(
      mockAudioRepository.stopNote(any),
    ).thenAnswer((_) async => Left(AudioFailure()));

    // act
    final result = await usecase(const StopNoteParams(note: tNote));

    // assert
    expect(result, Left(AudioFailure()));
    verify(mockAudioRepository.stopNote(tNote));
    verifyNoMoreInteractions(mockAudioRepository);
  });
}
