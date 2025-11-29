import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_piano/domain/repositories/recording_repository.dart';
import 'package:simple_piano/domain/usecases/start_recording.dart';

@GenerateMocks([RecordingRepository])
import 'start_recording_test.mocks.dart';

void main() {
  late StartRecording usecase;
  late MockRecordingRepository mockRecordingRepository;

  setUp(() {
    mockRecordingRepository = MockRecordingRepository();
    usecase = StartRecording(mockRecordingRepository);
  });

  test('should start recording and return recording ID', () async {
    // arrange
    when(
      mockRecordingRepository.startRecording(),
    ).thenAnswer((_) async => const Right('recording_id_123'));

    // act
    final result = await usecase();

    // assert
    expect(result, const Right('recording_id_123'));
    verify(mockRecordingRepository.startRecording());
  });
}
