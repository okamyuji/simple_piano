import 'package:flutter_test/flutter_test.dart';
import 'package:simple_piano/domain/entities/lesson.dart';

void main() {
  group('Lesson', () {
    const tLesson = Lesson(
      id: '1',
      title: 'Test Lesson',
      description: 'Test Description',
      level: 1,
      difficulty: LessonDifficulty.beginner,
      type: LessonType.noteRecognition,
      order: 1,
      practiceNotes: [60, 62, 64],
      recommendedDuration: 300,
      isLocked: false,
    );

    test('should have correct properties', () {
      expect(tLesson.id, '1');
      expect(tLesson.title, 'Test Lesson');
      expect(tLesson.description, 'Test Description');
      expect(tLesson.level, 1);
      expect(tLesson.difficulty, LessonDifficulty.beginner);
      expect(tLesson.type, LessonType.noteRecognition);
      expect(tLesson.order, 1);
      expect(tLesson.practiceNotes, [60, 62, 64]);
      expect(tLesson.recommendedDuration, 300);
      expect(tLesson.isLocked, false);
    });

    test('two lessons with same properties should be equal', () {
      const tLesson1 = Lesson(
        id: '1',
        title: 'Test',
        description: 'Test',
        level: 1,
        difficulty: LessonDifficulty.beginner,
        type: LessonType.noteRecognition,
        order: 1,
        practiceNotes: [60],
        recommendedDuration: 300,
        isLocked: false,
      );
      const tLesson2 = Lesson(
        id: '1',
        title: 'Test',
        description: 'Test',
        level: 1,
        difficulty: LessonDifficulty.beginner,
        type: LessonType.noteRecognition,
        order: 1,
        practiceNotes: [60],
        recommendedDuration: 300,
        isLocked: false,
      );
      expect(tLesson1, tLesson2);
    });

    test('copyWith should create a new lesson with updated properties', () {
      final updatedLesson = tLesson.copyWith(title: 'Updated Title', level: 2);
      expect(updatedLesson.id, '1');
      expect(updatedLesson.title, 'Updated Title');
      expect(updatedLesson.level, 2);
      expect(updatedLesson.description, 'Test Description');
    });
  });

  group('LessonDifficulty', () {
    test('should have correct enum values', () {
      expect(LessonDifficulty.values.length, 5);
      expect(LessonDifficulty.values, contains(LessonDifficulty.beginner));
      expect(LessonDifficulty.values, contains(LessonDifficulty.elementary));
      expect(LessonDifficulty.values, contains(LessonDifficulty.intermediate));
      expect(LessonDifficulty.values, contains(LessonDifficulty.advanced));
      expect(LessonDifficulty.values, contains(LessonDifficulty.expert));
    });
  });

  group('LessonType', () {
    test('should have correct enum values', () {
      expect(LessonType.values.length, 5);
      expect(LessonType.values, contains(LessonType.noteRecognition));
      expect(LessonType.values, contains(LessonType.melody));
      expect(LessonType.values, contains(LessonType.twoHands));
      expect(LessonType.values, contains(LessonType.rhythm));
      expect(LessonType.values, contains(LessonType.song));
    });
  });
}
