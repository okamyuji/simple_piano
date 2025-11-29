import 'package:flutter_test/flutter_test.dart';
import 'package:simple_piano/domain/entities/user_progress.dart';

void main() {
  group('UserProgress', () {
    final tProgress = UserProgress(
      userId: 'test_user',
      currentLevel: 1,
      completedLessons: const ['lesson_1'],
      totalPracticeTime: 300,
      totalNotesPlayed: 100,
      achievedMilestones: const ['first_lesson'],
      currentStreak: 3,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    test('should have correct properties', () {
      expect(tProgress.userId, 'test_user');
      expect(tProgress.currentLevel, 1);
      expect(tProgress.completedLessons, ['lesson_1']);
      expect(tProgress.totalPracticeTime, 300);
      expect(tProgress.totalNotesPlayed, 100);
      expect(tProgress.achievedMilestones, ['first_lesson']);
      expect(tProgress.currentStreak, 3);
      expect(tProgress.createdAt, DateTime(2024, 1, 1));
    });

    test('copyWith should create a new progress with updated properties', () {
      final updatedProgress = tProgress.copyWith(
        currentLevel: 2,
        totalNotesPlayed: 200,
      );
      expect(updatedProgress.userId, 'test_user');
      expect(updatedProgress.currentLevel, 2);
      expect(updatedProgress.totalNotesPlayed, 200);
      expect(updatedProgress.totalPracticeTime, 300);
    });

    test('copyWith should work with completedLessons', () {
      final updated = tProgress.copyWith(
        completedLessons: ['lesson_1', 'lesson_2'],
      );
      expect(updated.completedLessons.length, 2);
      expect(updated.completedLessons, contains('lesson_2'));
    });

    test('copyWith should work with achievedMilestones', () {
      final updated = tProgress.copyWith(
        achievedMilestones: ['first_lesson', 'second_lesson'],
      );
      expect(updated.achievedMilestones.length, 2);
      expect(updated.achievedMilestones, contains('second_lesson'));
    });

    test('copyWith should work with currentStreak', () {
      final updated = tProgress.copyWith(currentStreak: 4);
      expect(updated.currentStreak, 4);
    });

    test('copyWith should work with resetStreak', () {
      final updated = tProgress.copyWith(currentStreak: 0);
      expect(updated.currentStreak, 0);
    });
  });
}
