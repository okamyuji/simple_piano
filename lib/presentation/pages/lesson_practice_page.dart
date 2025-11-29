import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/note_utils.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/note.dart';
import '../../domain/entities/practice_session.dart';
import '../bloc/piano/piano_bloc.dart';
import '../bloc/piano/piano_event.dart';
import '../bloc/piano/piano_state.dart';
import '../bloc/progress/progress_bloc.dart';
import '../bloc/progress/progress_event.dart';
import '../widgets/piano_keyboard.dart';

/// レッスン練習画面
class LessonPracticePage extends StatefulWidget {
  final Lesson lesson;
  final PianoBloc? pianoBloc;

  const LessonPracticePage({required this.lesson, this.pianoBloc, super.key});

  @override
  State<LessonPracticePage> createState() => _LessonPracticePageState();
}

class _LessonPracticePageState extends State<LessonPracticePage> {
  int _currentNoteIndex = 0;
  int _correctCount = 0;
  int _totalAttempts = 0;
  DateTime? _startTime;
  final Set<int> _pressedNotes = {};

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  int get _targetNote => widget.lesson.practiceNotes[_currentNoteIndex];

  double get _accuracy =>
      _totalAttempts == 0 ? 0 : (_correctCount / _totalAttempts * 100);

  double get _progress =>
      _currentNoteIndex / widget.lesson.practiceNotes.length;

  bool get _isCompleted =>
      _currentNoteIndex >= widget.lesson.practiceNotes.length;

  void _onKeyPressed(BuildContext context, Note note) {
    setState(() {
      _pressedNotes.add(note.midiNumber);
    });
    final pianoBloc = context.read<PianoBloc>();
    pianoBloc.add(PianoKeyPressedEvent(note: note));

    // 正解判定
    if (note.midiNumber == _targetNote) {
      _correctCount++;
      _totalAttempts++;

      // 次の音符へ
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _currentNoteIndex++;
            if (_isCompleted) {
              _showCompletionDialog();
            }
          });
        }
      });
    } else {
      _totalAttempts++;
    }
  }

  void _onKeyReleased(BuildContext context, Note note) {
    setState(() {
      _pressedNotes.remove(note.midiNumber);
    });
    final pianoBloc = context.read<PianoBloc>();
    pianoBloc.add(PianoKeyReleasedEvent(note: note));
  }

  /// 練習セッションを記録
  void _recordPracticeSession() {
    if (!mounted) return;

    final duration = DateTime.now().difference(_startTime!);
    final session = PracticeSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: _startTime!,
      endTime: DateTime.now(),
      duration: duration.inSeconds,
      notesPlayed: _totalAttempts,
      lessonId: widget.lesson.id,
    );

    debugPrint(
      '[LessonPractice] セッション記録: ${session.duration}秒, ${session.notesPlayed}音符',
    );
    context.read<ProgressBloc>().add(
      ProgressSaveSessionEvent(session: session),
    );
  }

  void _showCompletionDialog() {
    final duration = DateTime.now().difference(_startTime!);
    final passed = _accuracy >= widget.lesson.targetAccuracy;

    // ダイアログを表示する前に必ず練習セッションを記録
    _recordPracticeSession();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(passed ? 'レッスン完了！' : 'もう少し！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('正解率: ${_accuracy.toStringAsFixed(1)}%'),
            Text('目標: ${widget.lesson.targetAccuracy}%'),
            Text('練習時間: ${duration.inSeconds}秒'),
            const SizedBox(height: 16),
            if (passed)
              const Text(
                '素晴らしい！次のレッスンに進みましょう！',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            else
              const Text(
                'もう一度チャレンジしてみましょう。',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, passed); // 完了状態を返す
            },
            child: const Text('レッスン一覧に戻る'),
          ),
          if (!passed)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _currentNoteIndex = 0;
                  _correctCount = 0;
                  _totalAttempts = 0;
                  _startTime = DateTime.now();
                });
              },
              child: const Text('もう一度'),
            )
          else
            ElevatedButton(
              onPressed: () {
                debugPrint('[LessonPractice] 次へボタンをクリック、完了状態を返します');
                Navigator.pop(context);
                Navigator.pop(context, true); // 完了状態を返す
              },
              child: const Text('次へ'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // PianoBlocを取得（引数で渡されていればそれを使用、なければcontextから取得）
    final pianoBloc = widget.pianoBloc ?? context.read<PianoBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('レッスンの進め方'),
                  content: Text(widget.lesson.description),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('閉じる'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PianoBloc, PianoState>(
        bloc: pianoBloc,
        buildWhen: (previous, current) =>
            previous.isInitialized != current.isInitialized ||
            previous.isLoading != current.isLoading ||
            previous.errorMessage != current.errorMessage,
        builder: (context, state) {
          if (state.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('エラー: ${state.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PianoBloc>().add(
                        const PianoInitializeEvent(),
                      );
                    },
                    child: const Text('再試行'),
                  ),
                ],
              ),
            );
          }

          if (!state.isInitialized) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('初期化中...'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 進捗表示
                  Column(
                    children: [
                      LinearProgressIndicator(value: _progress, minHeight: 8),
                      const SizedBox(height: 8),
                      Text(
                        '${_currentNoteIndex + 1} / ${widget.lesson.practiceNotes.length}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 現在の目標音符表示
                  if (!_isCompleted)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '次の音を弾いてください',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            NoteUtils.getNoteNameFromMidi(_targetNote),
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),

                  // 統計情報
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('正解', _correctCount.toString()),
                      _buildStat('正解率', '${_accuracy.toStringAsFixed(1)}%'),
                      _buildStat('目標', '${widget.lesson.targetAccuracy}%'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ピアノ鍵盤
                  PianoKeyboard(
                    startOctave: 4,
                    numberOfOctaves: 2,
                    pressedNotes: _pressedNotes,
                    highlightedNotes: _isCompleted ? {} : {_targetNote},
                    onKeyPressed: (note) => _onKeyPressed(context, note),
                    onKeyReleased: (note) => _onKeyReleased(context, note),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
