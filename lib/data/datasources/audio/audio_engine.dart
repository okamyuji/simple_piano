import 'dart:io';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/errors/exceptions.dart';
import '../../../domain/entities/note.dart';

/// オーディオエンジン（シンセサイズ音源）
@lazySingleton
class AudioEngine {
  // プレイヤープール（最大8つの同時発音）
  final List<AudioPlayer> _playerPool = [];
  int _currentPlayerIndex = 0;

  final Map<int, String> _wavFilePaths = {}; // MIDI番号 -> WAVファイルパス
  double _volume = 0.7;
  bool _isInitialized = false;
  Directory? _tempDir;

  /// オーディオエンジンを初期化
  Future<void> initialize() async {
    if (_isInitialized) return;

    debugPrint('[AudioEngine] 初期化開始');

    // 一時ディレクトリを取得
    _tempDir = await getTemporaryDirectory();

    // AudioContext設定
    final audioContext = AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: {AVAudioSessionOptions.mixWithOthers},
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: true,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.game,
        audioFocus: AndroidAudioFocus.gain,
      ),
    );
    AudioPlayer.global.setAudioContext(audioContext);

    // プレイヤープールを作成（8つの同時発音）
    for (int i = 0; i < 8; i++) {
      final player = AudioPlayer();
      await player.setPlayerMode(PlayerMode.lowLatency);
      await player.setVolume(_volume);
      _playerPool.add(player);
    }

    // デフォルトオクターブ（4-5）の音階を事前生成
    await preloadOctaveRange(4, 2);

    _isInitialized = true;
    debugPrint('[AudioEngine] 初期化完了');
  }

  /// 指定オクターブ範囲のWAVファイルを生成
  /// [startOctave] 開始オクターブ（例: 4）
  /// [numberOfOctaves] オクターブ数（例: 2で2オクターブ分）
  Future<void> preloadOctaveRange(int startOctave, int numberOfOctaves) async {
    if (_tempDir == null) {
      throw AudioException('一時ディレクトリが未初期化です');
    }

    // オクターブ範囲をMIDI番号に変換
    // オクターブ4のC = MIDI 60
    // 各オクターブは12音（半音階）
    final int startMidi = (startOctave + 1) * 12; // C of startOctave
    final int endMidi = startMidi + (numberOfOctaves * 12); // numberOfOctaves分

    debugPrint(
      '[AudioEngine] オクターブ $startOctave から $numberOfOctavesオクターブ分を生成中 (MIDI $startMidi-$endMidi)',
    );

    for (int midiNumber = startMidi; midiNumber <= endMidi; midiNumber++) {
      // 既に生成済みならスキップ
      if (_wavFilePaths.containsKey(midiNumber)) continue;

      final frequency = 440.0 * math.pow(2, (midiNumber - 69) / 12.0);
      final filePath = '${_tempDir!.path}/piano_$midiNumber.wav';
      final file = File(filePath);

      if (!await file.exists()) {
        final wavData = _generatePianoWav(frequency, 1.2);
        await file.writeAsBytes(wavData);
      }

      _wavFilePaths[midiNumber] = filePath;
    }

    debugPrint('[AudioEngine] 生成完了。現在のキャッシュ数: ${_wavFilePaths.length}個');
  }

  /// 音符を再生
  Future<void> playNote(Note note, {double volume = 1.0}) async {
    if (!_isInitialized || _playerPool.isEmpty) {
      throw AudioException('オーディオエンジンが初期化されていません');
    }

    // ハプティックフィードバック
    HapticFeedback.selectionClick();

    // 事前生成されたWAVファイルパスを取得
    String? filePath = _wavFilePaths[note.midiNumber];

    // ファイルが存在しない場合は動的生成
    if (filePath == null) {
      debugPrint('[AudioEngine] MIDI ${note.midiNumber} を動的生成');
      filePath = await _generateWavFileOnDemand(
        note.midiNumber,
        note.frequency,
      );
      if (filePath == null) {
        debugPrint('[AudioEngine] WAVファイル生成失敗: MIDI ${note.midiNumber}');
        return;
      }
    }

    // プレイヤープールから次のプレイヤーを取得（ラウンドロビン）
    final player = _playerPool[_currentPlayerIndex];
    _currentPlayerIndex = (_currentPlayerIndex + 1) % _playerPool.length;

    // 既存の再生を停止して新しい音を再生
    try {
      await player.stop();
      await player.setVolume(_volume * volume);
      await player.play(
        DeviceFileSource(filePath),
        mode: PlayerMode.lowLatency,
      );
    } catch (e) {
      debugPrint('[AudioEngine] 再生エラー: $e');
    }
  }

  /// 必要に応じてWAVファイルを動的生成
  Future<String?> _generateWavFileOnDemand(
    int midiNumber,
    double frequency,
  ) async {
    if (_tempDir == null) return null;

    final filePath = '${_tempDir!.path}/piano_$midiNumber.wav';
    final file = File(filePath);

    try {
      final wavData = _generatePianoWav(frequency, 1.2);
      await file.writeAsBytes(wavData);
      _wavFilePaths[midiNumber] = filePath;
      return filePath;
    } catch (e) {
      debugPrint('[AudioEngine] WAV生成エラー: $e');
      return null;
    }
  }

  /// シンプルで美しいピアノ音を生成
  Uint8List _generatePianoWav(double frequency, double duration) {
    const int sampleRate = 44100;
    final int numSamples = (sampleRate * duration).toInt();

    final List<int> wavData = [];

    // WAVヘッダー
    wavData.addAll('RIFF'.codeUnits);
    _addInt32(wavData, 36 + numSamples * 2);
    wavData.addAll('WAVE'.codeUnits);
    wavData.addAll('fmt '.codeUnits);
    _addInt32(wavData, 16);
    _addInt16(wavData, 1);
    _addInt16(wavData, 1);
    _addInt32(wavData, sampleRate);
    _addInt32(wavData, sampleRate * 2);
    _addInt16(wavData, 2);
    _addInt16(wavData, 16);
    wavData.addAll('data'.codeUnits);
    _addInt32(wavData, numSamples * 2);

    // シンプルなピアノ音（基音 + 控えめな倍音）
    for (int i = 0; i < numSamples; i++) {
      final double t = i / sampleRate;

      // 基音 + 2倍音 + 3倍音
      double value = math.sin(2.0 * math.pi * frequency * t);
      value += 0.3 * math.sin(2.0 * math.pi * frequency * 2 * t);
      value += 0.15 * math.sin(2.0 * math.pi * frequency * 3 * t);

      // ピアノらしい自然な減衰
      double envelope;
      if (t < 0.005) {
        envelope = t / 0.005; // 瞬時アタック
      } else {
        envelope = math.exp(-2.5 * (t - 0.005)); // なめらかな減衰
      }

      // 正規化して出力
      final int sample = (value * envelope * 32767 * 0.5).toInt().clamp(
        -32767,
        32767,
      );
      _addInt16(wavData, sample);
    }

    return Uint8List.fromList(wavData);
  }

  void _addInt32(List<int> list, int value) {
    list.add(value & 0xFF);
    list.add((value >> 8) & 0xFF);
    list.add((value >> 16) & 0xFF);
    list.add((value >> 24) & 0xFF);
  }

  void _addInt16(List<int> list, int value) {
    list.add(value & 0xFF);
    list.add((value >> 8) & 0xFF);
  }

  /// 音符の再生を停止（プレイヤープール方式では不要だが互換性のため残す）
  Future<void> stopNote(Note note) async {
    // プレイヤープール方式では個別の停止は行わない
    // 次の音が再生されるときに自動的に停止される
  }

  /// すべての音を停止
  Future<void> stopAllNotes() async {
    for (final player in _playerPool) {
      try {
        await player.stop();
      } catch (e) {
        debugPrint('[AudioEngine] 停止エラー: $e');
      }
    }
  }

  /// ボリュームを設定
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    for (final player in _playerPool) {
      await player.setVolume(_volume);
    }
  }

  /// 現在のボリュームを取得
  double getVolume() {
    return _volume;
  }

  /// オーディオエンジンを破棄
  Future<void> dispose() async {
    debugPrint('[AudioEngine] 破棄開始');

    // すべてのプレイヤーを停止して破棄
    for (final player in _playerPool) {
      try {
        await player.stop();
        await player.dispose();
      } catch (e) {
        debugPrint('[AudioEngine] プレイヤー破棄エラー: $e');
      }
    }
    _playerPool.clear();

    // WAVファイルを削除
    for (final filePath in _wavFilePaths.values) {
      try {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        debugPrint('[AudioEngine] ファイル削除エラー: $e');
      }
    }
    _wavFilePaths.clear();

    _isInitialized = false;
    debugPrint('[AudioEngine] 破棄完了');
  }
}
