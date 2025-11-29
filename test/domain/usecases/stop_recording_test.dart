import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_piano/domain/entities/recording.dart';
import 'package:simple_piano/domain/repositories/recording_repository.dart';
import 'package:simple_piano/domain/usecases/stop_recording.dart';

@GenerateMocks([RecordingRepository])
import 'start_recording_test.mocks.dart';

void main() {
  late StopRecording usecase;
  late MockRecordingRepository mockRecordingRepository;

  setUp(() {
    mockRecordingRepository = MockRecordingRepository();
    usecase = StopRecording(mockRecordingRepository);
  });

  final tRecording = Recording(
    id: 'recording_1',
    name: 'Test Recording',
    recordedAt: DateTime.now(),
    totalDuration: 30000,
    notes: const [],
  );

  test('should stop recording and return recording', () async {
    // arrange
    when(
      mockRecordingRepository.stopRecording(any, any),
    ).thenAnswer((_) async => Right(tRecording));

    // act
    final result = await usecase(
      const StopRecordingParams(recordingId: 'rec_1', name: 'Test'),
    );

    // assert
    expect(result, Right(tRecording));
    verify(mockRecordingRepository.stopRecording('rec_1', 'Test'));
  });
}
