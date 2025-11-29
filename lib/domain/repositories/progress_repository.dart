import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/daily_challenge.dart';
import '../entities/practice_session.dart';
import '../entities/user_progress.dart';

/// 進捗リポジトリインターフェース
abstract class ProgressRepository {
  /// ユーザー進捗を取得
  Future<Either<Failure, UserProgress>> getUserProgress();

  /// ユーザー進捗を保存
  Future<Either<Failure, void>> saveUserProgress(UserProgress progress);

  /// 練習セッションを保存
  Future<Either<Failure, void>> savePracticeSession(PracticeSession session);

  /// 練習セッションの履歴を取得
  Future<Either<Failure, List<PracticeSession>>> getPracticeSessions({
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// 今日のデイリーチャレンジを取得
  Future<Either<Failure, DailyChallenge>> getTodayChallenge();

  /// デイリーチャレンジの進捗を更新
  Future<Either<Failure, void>> updateChallengeProgress(
    String challengeId,
    int currentValue,
  );

  /// デイリーチャレンジを完了としてマーク
  Future<Either<Failure, void>> markChallengeComplete(String challengeId);

  /// ストリークを更新
  Future<Either<Failure, void>> updateStreak();

  /// マイルストーンを追加
  Future<Either<Failure, void>> addMilestone(String milestone);

  /// 統計情報を取得
  Future<Either<Failure, Map<String, dynamic>>> getStatistics();
}
