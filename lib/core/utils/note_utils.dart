import 'dart:math' as math;

import '../constants/app_constants.dart';

/// 音符ユーティリティクラス
class NoteUtils {
  NoteUtils._();

  /// MIDIノート番号から音符名を取得
  static String getNoteNameFromMidi(int midiNumber) {
    final noteIndex = midiNumber % 12;
    final octave = (midiNumber ~/ 12) - 1;
    return '${AppConstants.noteNames[noteIndex]}$octave';
  }

  /// 音符名からMIDIノート番号を取得
  static int getMidiNumberFromNote(String noteName, int octave) {
    final noteIndex = AppConstants.noteNames.indexOf(noteName);
    if (noteIndex == -1) return -1;
    return (octave + 1) * 12 + noteIndex;
  }

  /// 白鍵かどうかを判定
  static bool isWhiteKey(int midiNumber) {
    final noteIndex = midiNumber % 12;
    final noteName = AppConstants.noteNames[noteIndex];
    return !noteName.contains('#');
  }

  /// 黒鍵かどうかを判定
  static bool isBlackKey(int midiNumber) {
    return !isWhiteKey(midiNumber);
  }

  /// 周波数を計算（A4 = 440Hz基準）
  static double getFrequency(int midiNumber) {
    return 440.0 * math.pow(2.0, (midiNumber - 69) / 12.0);
  }

  /// キーインデックスからMIDIノート番号を取得
  static int getMidiNumberFromKeyIndex(int keyIndex) {
    final baseNote = 60; // C4
    return baseNote + keyIndex;
  }
}
