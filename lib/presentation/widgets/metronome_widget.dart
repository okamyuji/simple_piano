import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/constants/app_constants.dart';

/// メトロノームウィジェット
class MetronomeWidget extends StatefulWidget {
  final int initialBpm;
  final ValueChanged<int>? onBpmChanged;

  const MetronomeWidget({
    super.key,
    this.initialBpm = AppConstants.defaultBpm,
    this.onBpmChanged,
  });

  @override
  State<MetronomeWidget> createState() => _MetronomeWidgetState();
}

class _MetronomeWidgetState extends State<MetronomeWidget>
    with SingleTickerProviderStateMixin {
  late int _bpm;
  bool _isPlaying = false;
  Timer? _timer;
  late AnimationController _animationController;
  int _beatCount = 0;
  // メトロノーム用のプレイヤープール（2つで交互に使用）
  final List<AudioPlayer> _playerPool = [];
  int _currentPlayerIndex = 0;
  File? _downbeatFile;
  File? _upbeatFile;

  @override
  void initState() {
    super.initState();
    _bpm = widget.initialBpm;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _initializeMetronome();
  }

  Future<void> _initializeMetronome() async {
    final tempDir = await getTemporaryDirectory();

    // プレイヤープールを作成（2つのプレイヤー）
    for (int i = 0; i < 2; i++) {
      final player = AudioPlayer();
      await player.setPlayerMode(PlayerMode.lowLatency);
      _playerPool.add(player);
    }

    // 強拍音を生成
    _downbeatFile = File('${tempDir.path}/metronome_downbeat.wav');
    if (!await _downbeatFile!.exists()) {
      final wavData = _generateClickSound(1000.0, 0.05);
      await _downbeatFile!.writeAsBytes(wavData);
    }

    // 弱拍音を生成
    _upbeatFile = File('${tempDir.path}/metronome_upbeat.wav');
    if (!await _upbeatFile!.exists()) {
      final wavData = _generateClickSound(800.0, 0.05);
      await _upbeatFile!.writeAsBytes(wavData);
    }
  }

  void _playBeep(bool isDownbeat) async {
    if (_downbeatFile == null || _upbeatFile == null || _playerPool.isEmpty) {
      return;
    }

    try {
      // ハプティックフィードバック
      HapticFeedback.selectionClick();

      // プレイヤープールから次のプレイヤーを取得
      final player = _playerPool[_currentPlayerIndex];
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _playerPool.length;

      // ボリューム設定
      await player.setVolume(isDownbeat ? 0.7 : 0.4);

      // 前の音を停止して新しい音を再生
      await player.stop();

      // ファイルから再生
      final file = isDownbeat ? _downbeatFile! : _upbeatFile!;
      await player.play(
        DeviceFileSource(file.path),
        mode: PlayerMode.lowLatency,
      );
    } catch (e) {
      // エラーログ（デバッグ時のみ）
      assert(() {
        debugPrint('メトロノーム音再生エラー: $e');
        return true;
      }());
    }
  }

  /// クリック音のWAVデータを生成
  Uint8List _generateClickSound(double frequency, double duration) {
    const int sampleRate = 22050;
    final int numSamples = (sampleRate * duration).toInt();

    final List<int> wavData = [];

    // RIFF header
    wavData.addAll('RIFF'.codeUnits);
    _addInt32(wavData, 36 + numSamples * 2);
    wavData.addAll('WAVE'.codeUnits);

    // fmt chunk
    wavData.addAll('fmt '.codeUnits);
    _addInt32(wavData, 16);
    _addInt16(wavData, 1);
    _addInt16(wavData, 1);
    _addInt32(wavData, sampleRate);
    _addInt32(wavData, sampleRate * 2);
    _addInt16(wavData, 2);
    _addInt16(wavData, 16);

    // data chunk
    wavData.addAll('data'.codeUnits);
    _addInt32(wavData, numSamples * 2);

    // クリック音（短い正弦波）
    for (int i = 0; i < numSamples; i++) {
      final double t = i / sampleRate;
      final double value = math.sin(2.0 * math.pi * frequency * t);
      // 急速減衰エンベロープ
      final double envelope = math.exp(-30.0 * t);
      final int sample = (value * envelope * 32767 * 0.8).toInt();
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

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    for (final player in _playerPool) {
      player.dispose();
    }

    // 一時ファイルをクリーンアップ
    _downbeatFile?.delete();
    _upbeatFile?.delete();

    super.dispose();
  }

  void _toggleMetronome() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startMetronome();
      } else {
        _stopMetronome();
      }
    });
  }

  void _startMetronome() {
    final intervalMs = (60000 / _bpm).round();
    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      setState(() {
        _beatCount = (_beatCount + 1) % 4;
      });

      // ビープ音を再生
      _playBeep(_beatCount == 0);
    });
  }

  void _stopMetronome() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _beatCount = 0;
    });
  }

  void _changeBpm(int delta) {
    setState(() {
      _bpm = (_bpm + delta).clamp(AppConstants.minBpm, AppConstants.maxBpm);
      widget.onBpmChanged?.call(_bpm);

      if (_isPlaying) {
        _stopMetronome();
        _startMetronome();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('メトロノーム', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            // ビート表示
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isPlaying && index == _beatCount
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            // BPM表示
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_animationController.value * 0.1),
                  child: Text(
                    '$_bpm',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _isPlaying
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                );
              },
            ),
            Text(
              'BPM',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // BPMコントロール
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _changeBpm(-10),
                  icon: const Icon(Icons.remove_circle_outline),
                  iconSize: 32,
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _changeBpm(-1),
                  icon: const Icon(Icons.remove),
                  iconSize: 24,
                ),
                const SizedBox(width: 24),
                IconButton(
                  onPressed: () => _changeBpm(1),
                  icon: const Icon(Icons.add),
                  iconSize: 24,
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _changeBpm(10),
                  icon: const Icon(Icons.add_circle_outline),
                  iconSize: 32,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 再生/停止ボタン
            ElevatedButton.icon(
              key: Key(_isPlaying ? 'metronome_stop' : 'metronome_start'),
              onPressed: _toggleMetronome,
              icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
              label: Text(_isPlaying ? '停止' : '開始'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
