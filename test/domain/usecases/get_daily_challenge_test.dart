import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_piano/domain/entities/daily_challenge.dart';
import 'package:simple_piano/domain/repositories/progress_repository.dart';
import 'package:simple_piano/domain/usecases/get_daily_challenge.dart';

@GenerateMocks([ProgressRepository])
import 'record_session_test.mocks.dart';

void main() {
  late GetDailyChallenge usecase;
  late MockProgressRepository mockProgressRepository;

  setUp(() {
    mockProgressRepository = MockProgressRepository();
    usecase = GetDailyChallenge(mockProgressRepository);
  });

  final tChallenge = DailyChallenge(
    id: 'challenge_1',
    title: 'Practice 10 minutes',
    description: 'Practice for 10 minutes',
    type: ChallengeType.practiceTime,
    targetValue: 600,
    date: DateTime.now(),
  );

  test('should get today daily challenge from repository', () async {
    // arrange
    when(
      mockProgressRepository.getTodayChallenge(),
    ).thenAnswer((_) async => Right(tChallenge));

    // act
    final result = await usecase();

    // assert
    expect(result, Right(tChallenge));
    verify(mockProgressRepository.getTodayChallenge());
  });
}
