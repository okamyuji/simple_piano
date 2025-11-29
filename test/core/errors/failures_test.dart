import 'package:flutter_test/flutter_test.dart';
import 'package:simple_piano/core/errors/failures.dart';

void main() {
  group('Failures', () {
    test('CacheFailure should have correct message', () {
      const failure = CacheFailure('Test message');
      expect(failure.message, 'Test message');
    });

    test('AudioFailure should have correct message', () {
      const failure = AudioFailure('Test message');
      expect(failure.message, 'Test message');
    });

    test('DatabaseFailure should have correct message', () {
      const failure = DatabaseFailure('Test message');
      expect(failure.message, 'Test message');
    });

    test('RecordingFailure should have correct message', () {
      const failure = RecordingFailure('Test message');
      expect(failure.message, 'Test message');
    });

    test('two CacheFailures with same message should be equal', () {
      const failure1 = CacheFailure('Test');
      const failure2 = CacheFailure('Test');
      expect(failure1, failure2);
    });

    test('two AudioFailures with different messages should not be equal', () {
      const failure1 = AudioFailure('Message 1');
      const failure2 = AudioFailure('Message 2');
      expect(failure1, isNot(failure2));
    });

    test('CacheFailure and AudioFailure should not be equal', () {
      const failure1 = CacheFailure('Test');
      const failure2 = AudioFailure('Test');
      expect(failure1, isNot(failure2));
    });
  });
}
