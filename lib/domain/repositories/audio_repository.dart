import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/note.dart';

/// オーディオリポジトリインターフェース
abstract class AudioRepository {
  /// 音符を再生
  Future<Either<Failure, void>> playNote(Note note, {double volume = 1.0});

  /// 音符の再生を停止
  Future<Either<Failure, void>> stopNote(Note note);

  /// すべての音を停止
  Future<Either<Failure, void>> stopAllNotes();

  /// オーディオエンジンを初期化
  Future<Either<Failure, void>> initialize();

  /// オーディオエンジンを破棄
  Future<Either<Failure, void>> dispose();

  /// ボリュームを設定（0.0 - 1.0）
  Future<Either<Failure, void>> setVolume(double volume);

  /// 現在のボリュームを取得
  Future<Either<Failure, double>> getVolume();

  /// 指定オクターブ範囲のWAVファイルを事前生成
  Future<Either<Failure, void>> preloadOctaveRange(
    int startOctave,
    int numberOfOctaves,
  );
}
