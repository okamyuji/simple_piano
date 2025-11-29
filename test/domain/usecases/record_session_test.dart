import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_piano/domain/entities/practice_session.dart';
import 'package:simple_piano/domain/repositories/progress_repository.dart';
import 'package:simple_piano/domain/usecases/record_session.dart';

@GenerateMocks([ProgressRepository])
import 'record_session_test.mocks.dart';

void main() {
  late RecordSession usecase;
  late MockProgressRepository mockProgressRepository;

  setUp(() {
    mockProgressRepository = MockProgressRepository();
    usecase = RecordSession(mockProgressRepository);
  });

  final tSession = PracticeSession(
    id: 'session_1',
    lessonId: 'lesson_1',
    startTime: DateTime(2024, 1, 1, 10, 0),
    endTime: DateTime(2024, 1, 1, 10, 30),
    duration: 1800,
    notesPlayed: 50,
    accuracy: 0.85,
  );

  test('should record practice session', () async {
    // arrange
    when(
      mockProgressRepository.savePracticeSession(any),
    ).thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(RecordSessionParams(session: tSession));

    // assert
    expect(result, const Right(null));
    verify(mockProgressRepository.savePracticeSession(tSession));
  });
}
