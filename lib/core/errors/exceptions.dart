/// 基底Exceptionクラス
class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

/// サーバー例外
class ServerException extends AppException {
  const ServerException([super.message = 'サーバーエラーが発生しました']);
}

/// キャッシュ例外
class CacheException extends AppException {
  const CacheException([super.message = 'キャッシュエラーが発生しました']);
}

/// オーディオ例外
class AudioException extends AppException {
  const AudioException([super.message = '音声エラーが発生しました']);
}

/// データベース例外
class DatabaseException extends AppException {
  const DatabaseException([super.message = 'データベースエラーが発生しました']);
}

/// バリデーション例外
class ValidationException extends AppException {
  const ValidationException([super.message = '入力値が無効です']);
}

/// 録音例外
class RecordingException extends AppException {
  const RecordingException([super.message = '録音エラーが発生しました']);
}
