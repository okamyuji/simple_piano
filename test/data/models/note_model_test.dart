import 'package:flutter_test/flutter_test.dart';
import 'package:simple_piano/data/models/note_model.dart';
import 'package:simple_piano/domain/entities/note.dart';

void main() {
  group('NoteModel', () {
    const tNoteModel = NoteModel(
      midiNumber: 60,
      noteName: 'C4',
      octave: 4,
      frequency: 261.63,
      isWhiteKey: true,
    );

    const tNote = Note(
      midiNumber: 60,
      noteName: 'C4',
      octave: 4,
      frequency: 261.63,
      isWhiteKey: true,
    );

    test('should be a subclass of Note entity', () {
      expect(tNoteModel, isA<Note>());
    });

    test('fromEntity should create NoteModel from Note entity', () {
      final result = NoteModel.fromEntity(tNote);
      expect(result, tNoteModel);
    });

    test('toEntity should convert NoteModel to Note entity', () {
      final result = tNoteModel.toEntity();
      expect(result, tNote);
    });

    test('fromJson should return valid model', () {
      final Map<String, dynamic> json = {
        'midiNumber': 60,
        'noteName': 'C4',
        'octave': 4,
        'frequency': 261.63,
        'isWhiteKey': true,
      };

      final result = NoteModel.fromJson(json);
      expect(result, tNoteModel);
    });

    test('toJson should return JSON map', () {
      final result = tNoteModel.toJson();

      final expectedMap = {
        'midiNumber': 60,
        'noteName': 'C4',
        'octave': 4,
        'frequency': 261.63,
        'isWhiteKey': true,
      };

      expect(result, expectedMap);
    });
  });
}
