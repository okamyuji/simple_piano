import 'package:flutter_test/flutter_test.dart';
import 'package:simple_piano/data/services/lesson_data_service.dart';
import 'package:simple_piano/domain/entities/lesson.dart';

void main() {
  late LessonDataService service;

  setUp(() {
    service = LessonDataService();
  });

  group('LessonDataService', () {
    test('getAllLessons レッスンデータを返す', () {
      // Act
      final lessons = service.getAllLessons();

      // Assert
      expect(lessons, isNotEmpty);
      expect(lessons.length, greaterThan(10));
      
      // 最初のレッスンを確認
      final firstLesson = lessons.first;
      expect(firstLesson.id, 'lesson_1_1');
      expect(firstLesson.title, 'ドレミを覚えよう');
      expect(firstLesson.difficulty, LessonDifficulty.beginner);
      expect(firstLesson.level, 1);
      expect(firstLesson.order, 1);
      expect(firstLesson.practiceNotes, [60, 62, 64]);
    });

    test('getLessonsByLevel 正しくフィルタリングする', () {
      // Act
      final level1Lessons = service.getLessonsByLevel(1);
      final level2Lessons = service.getLessonsByLevel(2);

      // Assert
      expect(level1Lessons, isNotEmpty);
      expect(level2Lessons, isNotEmpty);
      
      // すべてのレッスンが指定したレベルであることを確認
      expect(level1Lessons.every((l) => l.level == 1), isTrue);
      expect(level2Lessons.every((l) => l.level == 2), isTrue);
    });

    test('getLessonById 正しいレッスンを返す', () {
      // Act
      final lesson = service.getLessonById('lesson_1_1');

      // Assert
      expect(lesson, isNotNull);
      expect(lesson?.title, 'ドレミを覚えよう');
    });

    test('lesson_2_1のIDが正しく設定されている', () {
      // Act
      final lesson = service.getLessonById('lesson_2_1');

      // Assert
      expect(lesson, isNotNull);
      expect(lesson?.title, 'きらきら星（前半）');
      expect(lesson?.level, 2);
    });
  });
}

