import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_piano/domain/entities/lesson.dart';
import 'package:simple_piano/domain/repositories/lesson_repository.dart';
import 'package:simple_piano/domain/usecases/get_lessons.dart';

@GenerateMocks([LessonRepository])
import 'get_lessons_test.mocks.dart';

void main() {
  late GetLessons usecase;
  late MockLessonRepository mockLessonRepository;

  setUp(() {
    mockLessonRepository = MockLessonRepository();
    usecase = GetLessons(mockLessonRepository);
  });

  final tLessons = [
    const Lesson(
      id: '1',
      title: 'Test Lesson',
      description: 'Test',
      level: 1,
      difficulty: LessonDifficulty.beginner,
      type: LessonType.noteRecognition,
      order: 1,
      practiceNotes: [60, 62, 64],
      recommendedDuration: 300,
      isLocked: false,
    ),
  ];

  test('should get all lessons from repository', () async {
    // arrange
    when(
      mockLessonRepository.getAllLessons(),
    ).thenAnswer((_) async => Right(tLessons));

    // act
    final result = await usecase(const GetLessonsParams());

    // assert
    expect(result, Right(tLessons));
    verify(mockLessonRepository.getAllLessons());
  });

  test('should get lessons by level', () async {
    // arrange
    when(
      mockLessonRepository.getLessonsByLevel(any),
    ).thenAnswer((_) async => Right(tLessons));

    // act
    final result = await usecase(const GetLessonsParams(level: 1));

    // assert
    expect(result, Right(tLessons));
    verify(mockLessonRepository.getLessonsByLevel(1));
  });
}
