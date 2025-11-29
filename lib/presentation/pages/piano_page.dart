import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/note.dart';
import '../../domain/entities/recording.dart';
import '../../injection.dart';
import '../bloc/piano/piano_bloc.dart';
import '../bloc/piano/piano_event.dart';
import '../bloc/piano/piano_state.dart';
import '../bloc/recording/recording_bloc.dart';
import '../bloc/recording/recording_event.dart';
import '../bloc/recording/recording_state.dart';
import '../widgets/piano_keyboard.dart';

/// ピアノ演奏画面
class PianoPage extends StatelessWidget {
  const PianoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RecordingBloc>(),
      child: const _PianoPageContent(),
    );
  }
}

class _PianoPageContent extends StatefulWidget {
  const _PianoPageContent();

  @override
  State<_PianoPageContent> createState() => _PianoPageContentState();
}

class _PianoPageContentState extends State<_PianoPageContent> {
  int _currentOctave = 4;
  final Set<int> _pressedNotes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自由演奏'),
        actions: [
          BlocBuilder<RecordingBloc, RecordingState>(
            builder: (context, state) {
              if (state.isRecording) {
                return IconButton(
                  key: const Key('stop_recording_button'),
                  icon: const Icon(Icons.stop),
                  tooltip: '録音停止',
                  onPressed: () => _stopRecording(context),
                );
              } else {
                return IconButton(
                  key: const Key('start_recording_button'),
                  icon: const Icon(Icons.fiber_manual_record),
                  tooltip: '録音開始',
                  onPressed: () {
                    context.read<RecordingBloc>().add(
                      const RecordingStartEvent(),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      body: BlocListener<PianoBloc, PianoState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        child: BlocBuilder<PianoBloc, PianoState>(
          builder: (context, state) {
            if (!state.isInitialized) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top,
                ),
                child: Column(
                  children: [
                    // コントロールパネル
                    _buildControlPanel(context, state),
                    const SizedBox(height: 8),
                    // ピアノ鍵盤
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PianoKeyboard(
                        startOctave: _currentOctave,
                        numberOfOctaves: 2,
                        pressedNotes: _pressedNotes,
                        onKeyPressed: (note) => _onKeyPressed(context, note),
                        onKeyReleased: (note) => _onKeyReleased(context, note),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// コントロールパネルを構築
  Widget _buildControlPanel(BuildContext context, PianoState state) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ボリュームコントロール
            Row(
              children: [
                const Icon(Icons.volume_up),
                Expanded(
                  child: Slider(
                    value: state.volume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: '${(state.volume * 100).round()}%',
                    onChanged: (value) {
                      context.read<PianoBloc>().add(
                        PianoVolumeChangedEvent(volume: value),
                      );
                    },
                  ),
                ),
                Text('${(state.volume * 100).round()}%'),
              ],
            ),
            const SizedBox(height: 8),
            // オクターブコントロール
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('オクターブ: '),
                IconButton(
                  key: const Key('octave_decrease_button'),
                  icon: const Icon(Icons.remove),
                  tooltip: 'オクターブを下げる',
                  onPressed: _currentOctave > 2
                      ? () {
                          setState(() {
                            _currentOctave--;
                          });
                          context.read<PianoBloc>().add(
                            PianoOctaveChangedEvent(octave: _currentOctave),
                          );
                        }
                      : null,
                ),
                Text(
                  '$_currentOctave',
                  key: const Key('octave_value'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  key: const Key('octave_increase_button'),
                  icon: const Icon(Icons.add),
                  tooltip: 'オクターブを上げる',
                  onPressed: _currentOctave < 6
                      ? () {
                          setState(() {
                            _currentOctave++;
                          });
                          context.read<PianoBloc>().add(
                            PianoOctaveChangedEvent(octave: _currentOctave),
                          );
                        }
                      : null,
                ),
              ],
            ),
            // 録音状態表示
            BlocBuilder<RecordingBloc, RecordingState>(
              builder: (context, recordingState) {
                if (recordingState.isRecording) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fiber_manual_record, color: Colors.red),
                        SizedBox(width: 8),
                        Text('録音中...'),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// キー押下処理
  void _onKeyPressed(BuildContext context, Note note) {
    setState(() {
      _pressedNotes.add(note.midiNumber);
    });
    context.read<PianoBloc>().add(PianoKeyPressedEvent(note: note));

    // 録音中の場合は音符を追加
    final recordingState = context.read<RecordingBloc>().state;
    if (recordingState.isRecording) {
      final recordedNote = RecordedNote(
        midiNumber: note.midiNumber,
        startTime: DateTime.now().millisecondsSinceEpoch,
        endTime: DateTime.now().millisecondsSinceEpoch + 500,
        velocity: 64,
      );
      context.read<RecordingBloc>().add(
        RecordingAddNoteEvent(note: recordedNote),
      );
    }
  }

  /// キーリリース処理
  void _onKeyReleased(BuildContext context, Note note) {
    setState(() {
      _pressedNotes.remove(note.midiNumber);
    });
    context.read<PianoBloc>().add(PianoKeyReleasedEvent(note: note));
  }

  /// 録音停止処理
  Future<void> _stopRecording(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('録音を保存'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: '録音名',
            hintText: '例: 練習曲1',
          ),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, '録音_${DateTime.now().toString()}'),
            child: const Text('保存'),
          ),
        ],
      ),
    );

    if (result != null && context.mounted) {
      context.read<RecordingBloc>().add(RecordingStopEvent(name: result));
    }
  }
}
