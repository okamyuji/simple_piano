import 'package:equatable/equatable.dart';

/// 基底Failureクラス
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// サーバーエラー
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'サーバーエラーが発生しました']);
}

/// キャッシュエラー
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'キャッシュエラーが発生しました']);
}

/// オーディオエラー
class AudioFailure extends Failure {
  const AudioFailure([super.message = '音声エラーが発生しました']);
}

/// データベースエラー
class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'データベースエラーが発生しました']);
}

/// バリデーションエラー
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = '入力値が無効です']);
}

/// 録音エラー
class RecordingFailure extends Failure {
  const RecordingFailure([super.message = '録音エラーが発生しました']);
}
