import 'package:flutter_test/flutter_test.dart';
import 'package:simple_piano/domain/entities/note.dart';

void main() {
  group('Note', () {
    test('should have correct properties', () {
      // arrange
      const note = Note(
        midiNumber: 60,
        noteName: 'C4',
        octave: 4,
        frequency: 261.63,
        isWhiteKey: true,
      );

      // assert
      expect(note.midiNumber, 60);
      expect(note.noteName, 'C4');
      expect(note.octave, 4);
      expect(note.frequency, 261.63);
      expect(note.isWhiteKey, true);
    });

    test('two notes with same properties should be equal', () {
      // arrange
      const note1 = Note(
        midiNumber: 60,
        noteName: 'C4',
        octave: 4,
        frequency: 261.63,
        isWhiteKey: true,
      );
      const note2 = Note(
        midiNumber: 60,
        noteName: 'C4',
        octave: 4,
        frequency: 261.63,
        isWhiteKey: true,
      );

      // assert
      expect(note1, note2);
    });

    test('two notes with different properties should not be equal', () {
      // arrange
      const note1 = Note(
        midiNumber: 60,
        noteName: 'C4',
        octave: 4,
        frequency: 261.63,
        isWhiteKey: true,
      );
      const note2 = Note(
        midiNumber: 62,
        noteName: 'D4',
        octave: 4,
        frequency: 293.66,
        isWhiteKey: true,
      );

      // assert
      expect(note1, isNot(note2));
    });

    test('copyWith should create a new note with updated properties', () {
      // arrange
      const note = Note(
        midiNumber: 60,
        noteName: 'C4',
        octave: 4,
        frequency: 261.63,
        isWhiteKey: true,
      );

      // act
      final newNote = note.copyWith(midiNumber: 62, noteName: 'D4');

      // assert
      expect(newNote.midiNumber, 62);
      expect(newNote.noteName, 'D4');
      expect(newNote.octave, 4);
      expect(newNote.frequency, 261.63);
    });
  });
}
