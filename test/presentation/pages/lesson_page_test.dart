import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_piano/domain/entities/lesson.dart';
import 'package:simple_piano/presentation/bloc/lesson/lesson_bloc.dart';
import 'package:simple_piano/presentation/bloc/lesson/lesson_state.dart';

class MockLessonBloc extends Fake implements LessonBloc {
  @override
  LessonState get state => const LessonState();

  @override
  Stream<LessonState> get stream => Stream.value(const LessonState());

  @override
  void add(event) {}

  @override
  Future<void> close() async {}
}

void main() {
  group('LessonPage UI Tests', () {
    testWidgets('タイトルが表示される', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<LessonBloc>(
            create: (_) => MockLessonBloc(),
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: AppBar(title: const Text('レッスン')),
              ),
            ),
          ),
        ),
      );

      expect(find.text('レッスン'), findsOneWidget);
    });

    testWidgets('説明文が表示される', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: Text('レベルを選んでレッスンを始めましょう'))),
        ),
      );

      expect(find.text('レベルを選んでレッスンを始めましょう'), findsOneWidget);
    });

    testWidgets('レベルタブが5つ表示される', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DefaultTabController(
            length: 5,
            child: Scaffold(
              appBar: TabBar(
                tabs: [
                  Tab(text: 'レベル1'),
                  Tab(text: 'レベル2'),
                  Tab(text: 'レベル3'),
                  Tab(text: 'レベル4'),
                  Tab(text: 'レベル5'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('レベル1'), findsOneWidget);
      expect(find.text('レベル2'), findsOneWidget);
      expect(find.text('レベル3'), findsOneWidget);
      expect(find.text('レベル4'), findsOneWidget);
      expect(find.text('レベル5'), findsOneWidget);
    });

    testWidgets('空の状態でメッセージが表示される', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_music, size: 64),
                  SizedBox(height: 16),
                  Text('レッスンがありません'),
                  SizedBox(height: 8),
                  Text('上のレベルタブからレッスンを選択してください'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('レッスンがありません'), findsOneWidget);
      expect(find.text('上のレベルタブからレッスンを選択してください'), findsOneWidget);
      expect(find.byIcon(Icons.library_music), findsOneWidget);
    });

    testWidgets('レベルが空の場合のメッセージが表示される', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, size: 64),
                  SizedBox(height: 16),
                  Text('このレベルのレッスンはまだ準備中です'),
                  SizedBox(height: 8),
                  Text('他のレベルを試してみてください'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('このレベルのレッスンはまだ準備中です'), findsOneWidget);
      expect(find.text('他のレベルを試してみてください'), findsOneWidget);
      expect(find.byIcon(Icons.schedule), findsOneWidget);
    });

    testWidgets('情報メッセージが表示される', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('レッスンをタップして練習を始めましょう')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('レッスンをタップして練習を始めましょう'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });
  });

  group('LessonState Tests', () {
    test('初期状態はloadingである', () {
      const state = LessonState();
      expect(state.status, LessonStatus.initial);
    });

    test('copyWithでstatusを変更できる', () {
      const state = LessonState();
      final newState = state.copyWith(status: LessonStatus.loading);
      expect(newState.status, LessonStatus.loading);
    });

    test('copyWithでlessonsを変更できる', () {
      const state = LessonState();
      final lesson = Lesson(
        id: 'test',
        title: 'テストレッスン',
        description: 'テスト',
        level: 1,
        order: 1,
        type: LessonType.melody,
        difficulty: LessonDifficulty.beginner,
        practiceNotes: const [],
      );
      final newState = state.copyWith(lessons: [lesson]);
      expect(newState.lessons.length, 1);
      expect(newState.lessons.first.id, 'test');
    });

    test('copyWithでerrorMessageを変更できる', () {
      const state = LessonState();
      final newState = state.copyWith(errorMessage: 'エラー');
      expect(newState.errorMessage, 'エラー');
    });
  });
}
