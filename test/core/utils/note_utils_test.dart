import 'package:flutter_test/flutter_test.dart';
import 'package:simple_piano/core/utils/note_utils.dart';

void main() {
  group('NoteUtils', () {
    group('getNoteNameFromMidi', () {
      test('should return C4 for MIDI 60', () {
        expect(NoteUtils.getNoteNameFromMidi(60), 'C4');
      });

      test('should return C#4 for MIDI 61', () {
        expect(NoteUtils.getNoteNameFromMidi(61), 'C#4');
      });

      test('should return A4 for MIDI 69', () {
        expect(NoteUtils.getNoteNameFromMidi(69), 'A4');
      });
    });

    group('getMidiNumberFromNote', () {
      test('should return 60 for C4', () {
        expect(NoteUtils.getMidiNumberFromNote('C', 4), 60);
      });

      test('should return 61 for C#4', () {
        expect(NoteUtils.getMidiNumberFromNote('C#', 4), 61);
      });

      test('should return 69 for A4', () {
        expect(NoteUtils.getMidiNumberFromNote('A', 4), 69);
      });

      test('should return -1 for invalid note name', () {
        expect(NoteUtils.getMidiNumberFromNote('X', 4), -1);
      });
    });

    group('isWhiteKey', () {
      test('should return true for C (MIDI 60)', () {
        expect(NoteUtils.isWhiteKey(60), true);
      });

      test('should return false for C# (MIDI 61)', () {
        expect(NoteUtils.isWhiteKey(61), false);
      });

      test('should return true for A (MIDI 69)', () {
        expect(NoteUtils.isWhiteKey(69), true);
      });
    });

    group('isBlackKey', () {
      test('should return false for C (MIDI 60)', () {
        expect(NoteUtils.isBlackKey(60), false);
      });

      test('should return true for C# (MIDI 61)', () {
        expect(NoteUtils.isBlackKey(61), true);
      });
    });

    group('getFrequency', () {
      test('should calculate frequency for A4 (440 Hz)', () {
        expect(NoteUtils.getFrequency(69), closeTo(440.0, 0.01));
      });

      test('should calculate frequency for C4 (261.63 Hz)', () {
        expect(NoteUtils.getFrequency(60), closeTo(261.63, 0.01));
      });

      test('should calculate frequency for A5 (880 Hz)', () {
        expect(NoteUtils.getFrequency(81), closeTo(880.0, 0.01));
      });
    });

    group('getMidiNumberFromKeyIndex', () {
      test('should return 60 for key index 0', () {
        expect(NoteUtils.getMidiNumberFromKeyIndex(0), 60);
      });

      test('should return 61 for key index 1', () {
        expect(NoteUtils.getMidiNumberFromKeyIndex(1), 61);
      });

      test('should return 72 for key index 12', () {
        expect(NoteUtils.getMidiNumberFromKeyIndex(12), 72);
      });
    });
  });
}
