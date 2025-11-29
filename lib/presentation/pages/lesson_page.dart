import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import '../bloc/lesson/lesson_bloc.dart';
import '../bloc/lesson/lesson_event.dart';
import '../bloc/lesson/lesson_state.dart';
import '../bloc/piano/piano_bloc.dart';
import '../widgets/lesson_card.dart';
import 'lesson_practice_page.dart';

/// レッスン一覧画面
class LessonPage extends StatelessWidget {
  const LessonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LessonBloc>()..add(const LessonLoadAllEvent()),
      child: const _LessonPageContent(),
    );
  }
}

class _LessonPageContent extends StatefulWidget {
  const _LessonPageContent();

  @override
  State<_LessonPageContent> createState() => _LessonPageContentState();
}

class _LessonPageContentState extends State<_LessonPageContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('レッスン'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'レベルを選んでレッスンを始めましょう',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'レベル1'),
                  Tab(text: 'レベル2'),
                  Tab(text: 'レベル3'),
                  Tab(text: 'レベル4'),
                  Tab(text: 'レベル5'),
                ],
                onTap: (index) {
                  context.read<LessonBloc>().add(
                    LessonLoadByLevelEvent(level: index + 1),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: BlocListener<LessonBloc, LessonState>(
        listener: (context, state) {
          if (state.status == LessonStatus.error &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        child: BlocBuilder<LessonBloc, LessonState>(
          builder: (context, state) {
            if (state.status == LessonStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.lessons.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.library_music,
                        size: 64,
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      const Text('レッスンがありません', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      const Text(
                        '上のレベルタブからレッスンを選択してください',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return TabBarView(
              controller: _tabController,
              children: List.generate(5, (index) {
                final level = index + 1;
                final levelLessons = state.lessons
                    .where((l) => l.level == level)
                    .toList();

                return _buildLessonList(context, levelLessons);
              }),
            );
          },
        ),
      ),
    );
  }

  /// レッスンリストを構築
  Widget _buildLessonList(BuildContext context, List lessons) {
    if (lessons.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.schedule,
                size: 64,
                color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'このレベルのレッスンはまだ準備中です',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                '他のレベルを試してみてください',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'レッスンをタップして練習を始めましょう',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: LessonCard(
                  lesson: lesson,
                  onTap: () => _startLesson(context, lesson.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// レッスンを開始
  Future<void> _startLesson(BuildContext context, String lessonId) async {
    final bloc = context.read<LessonBloc>();
    final state = bloc.state;
    final lesson = state.lessons.firstWhere((l) => l.id == lessonId);

    bloc.add(LessonStartEvent(lessonId: lessonId));

    // Navigator.pushを使って直接遷移
    // PianoBlocを明示的に渡す
    final pianoBloc = context.read<PianoBloc>();
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LessonPracticePage(lesson: lesson, pianoBloc: pianoBloc),
      ),
    );

    // レッスンから戻ってきた時、完了していたら進捗を保存してレッスン一覧を再読み込み
    if (result == true && mounted) {
      debugPrint('レッスン完了を検知、進捗を保存します: $lessonId');

      // 進捗を保存
      bloc.add(
        LessonCompleteEvent(
          lessonId: lessonId,
          accuracy: 100, // 完了時は100%として保存
        ),
      );

      // 少し待ってからレッスン一覧を再読み込み（保存完了を待つ）
      await Future.delayed(const Duration(milliseconds: 300));

      // レッスン一覧を再読み込み
      bloc.add(const LessonLoadAllEvent());

      debugPrint('レッスン一覧を再読み込みしました');
    }
  }
}
