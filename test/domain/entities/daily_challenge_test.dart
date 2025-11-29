import 'package:flutter_test/flutter_test.dart';
import 'package:simple_piano/domain/entities/daily_challenge.dart';

void main() {
  group('DailyChallenge', () {
    final tChallenge = DailyChallenge(
      id: 'challenge_1',
      title: 'Practice 10 minutes',
      description: 'Practice for 10 minutes',
      type: ChallengeType.practiceTime,
      targetValue: 600,
      currentValue: 300,
      rewardPoints: 10,
      date: DateTime(2024, 1, 1),
      isCompleted: false,
    );

    test('should have correct properties', () {
      expect(tChallenge.id, 'challenge_1');
      expect(tChallenge.title, 'Practice 10 minutes');
      expect(tChallenge.description, 'Practice for 10 minutes');
      expect(tChallenge.type, ChallengeType.practiceTime);
      expect(tChallenge.targetValue, 600);
      expect(tChallenge.currentValue, 300);
      expect(tChallenge.rewardPoints, 10);
      expect(tChallenge.date, DateTime(2024, 1, 1));
      expect(tChallenge.isCompleted, false);
    });

    test('progressPercentage should calculate correctly', () {
      expect(tChallenge.progressPercentage, 50.0);
    });

    test('progressPercentage should be clamped to 100', () {
      final completed = tChallenge.copyWith(currentValue: 700);
      expect(completed.progressPercentage, 100.0);
    });

    test('isToday should return correct value', () {
      final today = DailyChallenge(
        id: 'challenge_today',
        title: 'Today',
        description: 'Today',
        type: ChallengeType.practiceTime,
        targetValue: 100,
        date: DateTime.now(),
      );
      expect(today.isToday, true);
      expect(tChallenge.isToday, false);
    });

    test('copyWith should create a new challenge with updated properties', () {
      final updated = tChallenge.copyWith(currentValue: 400, isCompleted: true);
      expect(updated.currentValue, 400);
      expect(updated.isCompleted, true);
      expect(updated.targetValue, 600);
    });
  });

  group('ChallengeType', () {
    test('should have correct enum values', () {
      expect(ChallengeType.values.length, 5);
      expect(ChallengeType.values, contains(ChallengeType.practiceTime));
      expect(ChallengeType.values, contains(ChallengeType.noteCount));
      expect(ChallengeType.values, contains(ChallengeType.accuracy));
      expect(ChallengeType.values, contains(ChallengeType.streak));
      expect(ChallengeType.values, contains(ChallengeType.lessonCompletion));
    });
  });
}
