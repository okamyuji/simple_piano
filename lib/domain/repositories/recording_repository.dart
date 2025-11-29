import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/recording.dart';

/// 録音リポジトリインターフェース
abstract class RecordingRepository {
  /// 録音を開始
  Future<Either<Failure, String>> startRecording();

  /// 音符を録音に追加
  Future<Either<Failure, void>> addNoteToRecording(
    String recordingId,
    RecordedNote note,
  );

  /// 録音を停止して保存
  Future<Either<Failure, Recording>> stopRecording(
    String recordingId,
    String name,
  );

  /// 録音をキャンセル
  Future<Either<Failure, void>> cancelRecording(String recordingId);

  /// すべての録音を取得
  Future<Either<Failure, List<Recording>>> getAllRecordings();

  /// IDで録音を取得
  Future<Either<Failure, Recording>> getRecordingById(String id);

  /// 録音を再生
  Future<Either<Failure, void>> playRecording(Recording recording);

  /// 録音の再生を停止
  Future<Either<Failure, void>> stopPlayback();

  /// 録音を削除
  Future<Either<Failure, void>> deleteRecording(String id);

  /// 録音をエクスポート
  Future<Either<Failure, String>> exportRecording(String id, String format);
}
