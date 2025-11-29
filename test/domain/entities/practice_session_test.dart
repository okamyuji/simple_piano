import 'package:flutter_test/flutter_test.dart';
import 'package:simple_piano/domain/entities/practice_session.dart';

void main() {
  group('PracticeSession', () {
    final tSession = PracticeSession(
      id: 'session_1',
      lessonId: 'lesson_1',
      startTime: DateTime(2024, 1, 1, 10, 0),
      endTime: DateTime(2024, 1, 1, 10, 30),
      duration: 1800,
      notesPlayed: 50,
      accuracy: 0.85,
    );

    test('should have correct properties', () {
      expect(tSession.id, 'session_1');
      expect(tSession.lessonId, 'lesson_1');
      expect(tSession.startTime, DateTime(2024, 1, 1, 10, 0));
      expect(tSession.endTime, DateTime(2024, 1, 1, 10, 30));
      expect(tSession.duration, 1800);
      expect(tSession.notesPlayed, 50);
      expect(tSession.accuracy, 0.85);
    });

    test('isCompleted should return true when endTime is set', () {
      expect(tSession.isCompleted, true);
    });

    test('isActive should return false when endTime is set', () {
      expect(tSession.isActive, false);
    });

    test('copyWith should create a new session with updated properties', () {
      final updated = tSession.copyWith(notesPlayed: 100, accuracy: 0.95);
      expect(updated.notesPlayed, 100);
      expect(updated.accuracy, 0.95);
      expect(updated.id, 'session_1');
    });

    test('two sessions with same properties should be equal', () {
      final tSession1 = PracticeSession(
        id: 'session_1',
        lessonId: 'lesson_1',
        startTime: DateTime(2024, 1, 1, 10, 0),
        endTime: DateTime(2024, 1, 1, 10, 30),
        duration: 1800,
        notesPlayed: 50,
        accuracy: 0.85,
      );
      final tSession2 = PracticeSession(
        id: 'session_1',
        lessonId: 'lesson_1',
        startTime: DateTime(2024, 1, 1, 10, 0),
        endTime: DateTime(2024, 1, 1, 10, 30),
        duration: 1800,
        notesPlayed: 50,
        accuracy: 0.85,
      );
      expect(tSession1, tSession2);
    });
  });
}
