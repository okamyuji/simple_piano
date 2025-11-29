import 'package:flutter_test/flutter_test.dart';
import 'package:simple_piano/domain/entities/recording.dart';

void main() {
  group('Recording', () {
    final tRecording = Recording(
      id: 'recording_1',
      name: 'Test Recording',
      recordedAt: DateTime(2024, 1, 1),
      totalDuration: 30000,
      notes: const [],
    );

    test('should have correct properties', () {
      expect(tRecording.id, 'recording_1');
      expect(tRecording.name, 'Test Recording');
      expect(tRecording.recordedAt, DateTime(2024, 1, 1));
      expect(tRecording.totalDuration, 30000);
      expect(tRecording.notes, const []);
    });

    test('copyWith should create new recording with updated properties', () {
      final updated = tRecording.copyWith(
        name: 'Updated Name',
        totalDuration: 60000,
      );
      expect(updated.name, 'Updated Name');
      expect(updated.totalDuration, 60000);
      expect(updated.id, 'recording_1');
    });

    test('two recordings with same properties should be equal', () {
      final tRecording1 = Recording(
        id: 'recording_1',
        name: 'Test',
        recordedAt: DateTime(2024, 1, 1),
        totalDuration: 30000,
        notes: const [],
      );
      final tRecording2 = Recording(
        id: 'recording_1',
        name: 'Test',
        recordedAt: DateTime(2024, 1, 1),
        totalDuration: 30000,
        notes: const [],
      );
      expect(tRecording1, tRecording2);
    });

    test('isEmpty should return true when no notes', () {
      expect(tRecording.isEmpty, true);
    });

    test('noteCount should return correct count', () {
      expect(tRecording.noteCount, 0);
    });
  });

  group('RecordedNote', () {
    const tNote = RecordedNote(
      midiNumber: 60,
      velocity: 64,
      startTime: 100,
      endTime: 600,
    );

    test('should have correct properties', () {
      expect(tNote.midiNumber, 60);
      expect(tNote.velocity, 64);
      expect(tNote.startTime, 100);
      expect(tNote.endTime, 600);
    });

    test('duration should calculate correctly', () {
      expect(tNote.duration, 500);
    });
  });
}
