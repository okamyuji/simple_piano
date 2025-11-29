import 'package:flutter/material.dart';

import '../../core/utils/note_utils.dart';
import '../../domain/entities/note.dart';
import 'piano_key.dart';

/// ピアノ鍵盤ウィジェット
class PianoKeyboard extends StatelessWidget {
  final int startOctave;
  final int numberOfOctaves;
  final Set<int> pressedNotes;
  final Set<int> highlightedNotes;
  final Function(Note) onKeyPressed;
  final Function(Note) onKeyReleased;

  const PianoKeyboard({
    super.key,
    this.startOctave = 4,
    this.numberOfOctaves = 2,
    required this.pressedNotes,
    this.highlightedNotes = const {},
    required this.onKeyPressed,
    required this.onKeyReleased,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final whiteKeyWidth = constraints.maxWidth / (numberOfOctaves * 7);
        final blackKeyWidth = whiteKeyWidth * 0.6;
        final whiteKeyHeight = 200.0;
        final blackKeyHeight = whiteKeyHeight * 0.6;

        return SizedBox(
          height: whiteKeyHeight,
          child: Stack(
            children: [
              // 白鍵
              _buildWhiteKeys(whiteKeyWidth, whiteKeyHeight),
              // 黒鍵
              _buildBlackKeys(whiteKeyWidth, blackKeyWidth, blackKeyHeight),
            ],
          ),
        );
      },
    );
  }

  /// 白鍵を構築
  Widget _buildWhiteKeys(double keyWidth, double keyHeight) {
    final whiteKeys = <Widget>[];
    int whiteKeyIndex = 0;

    for (
      int octave = startOctave;
      octave < startOctave + numberOfOctaves;
      octave++
    ) {
      for (final noteName in ['C', 'D', 'E', 'F', 'G', 'A', 'B']) {
        final midiNumber = NoteUtils.getMidiNumberFromNote(noteName, octave);
        final note = Note(
          midiNumber: midiNumber,
          noteName: NoteUtils.getNoteNameFromMidi(midiNumber),
          octave: octave,
          frequency: NoteUtils.getFrequency(midiNumber),
          isWhiteKey: true,
        );

        whiteKeys.add(
          Positioned(
            left: whiteKeyIndex * keyWidth,
            child: PianoKey(
              note: note,
              isPressed: pressedNotes.contains(midiNumber),
              isHighlighted: highlightedNotes.contains(midiNumber),
              onPressed: () => onKeyPressed(note),
              onReleased: () => onKeyReleased(note),
              width: keyWidth,
              height: keyHeight,
            ),
          ),
        );

        whiteKeyIndex++;
      }
    }

    return Stack(children: whiteKeys);
  }

  /// 黒鍵を構築
  Widget _buildBlackKeys(
    double whiteKeyWidth,
    double blackKeyWidth,
    double blackKeyHeight,
  ) {
    final blackKeys = <Widget>[];
    int whiteKeyIndex = 0;

    for (
      int octave = startOctave;
      octave < startOctave + numberOfOctaves;
      octave++
    ) {
      // C#
      _addBlackKey(
        blackKeys,
        'C#',
        octave,
        whiteKeyIndex,
        whiteKeyWidth,
        blackKeyWidth,
        blackKeyHeight,
      );
      whiteKeyIndex++;

      // D#
      _addBlackKey(
        blackKeys,
        'D#',
        octave,
        whiteKeyIndex,
        whiteKeyWidth,
        blackKeyWidth,
        blackKeyHeight,
      );
      whiteKeyIndex += 2; // E の後はスキップ

      // F#
      _addBlackKey(
        blackKeys,
        'F#',
        octave,
        whiteKeyIndex,
        whiteKeyWidth,
        blackKeyWidth,
        blackKeyHeight,
      );
      whiteKeyIndex++;

      // G#
      _addBlackKey(
        blackKeys,
        'G#',
        octave,
        whiteKeyIndex,
        whiteKeyWidth,
        blackKeyWidth,
        blackKeyHeight,
      );
      whiteKeyIndex++;

      // A#
      _addBlackKey(
        blackKeys,
        'A#',
        octave,
        whiteKeyIndex,
        whiteKeyWidth,
        blackKeyWidth,
        blackKeyHeight,
      );
      whiteKeyIndex += 2; // B の後はスキップ
    }

    return Stack(children: blackKeys);
  }

  /// 黒鍵を追加
  void _addBlackKey(
    List<Widget> blackKeys,
    String noteName,
    int octave,
    int whiteKeyIndex,
    double whiteKeyWidth,
    double blackKeyWidth,
    double blackKeyHeight,
  ) {
    final midiNumber = NoteUtils.getMidiNumberFromNote(noteName, octave);
    final note = Note(
      midiNumber: midiNumber,
      noteName: NoteUtils.getNoteNameFromMidi(midiNumber),
      octave: octave,
      frequency: NoteUtils.getFrequency(midiNumber),
      isWhiteKey: false,
    );

    blackKeys.add(
      Positioned(
        left:
            (whiteKeyIndex * whiteKeyWidth) +
            whiteKeyWidth -
            (blackKeyWidth / 2),
        child: PianoKey(
          note: note,
          isPressed: pressedNotes.contains(midiNumber),
          isHighlighted: highlightedNotes.contains(midiNumber),
          onPressed: () => onKeyPressed(note),
          onReleased: () => onKeyReleased(note),
          width: blackKeyWidth,
          height: blackKeyHeight,
        ),
      ),
    );
  }
}
