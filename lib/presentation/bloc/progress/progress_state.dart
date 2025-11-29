import 'package:equatable/equatable.dart';

import '../../../domain/entities/daily_challenge.dart';
import '../../../domain/entities/user_progress.dart';

/// 進捗ステータス
enum ProgressStatus { initial, loading, loaded, saving, saved, error }

/// 進捗ステート
class ProgressState extends Equatable {
  /// ステータス
  final ProgressStatus status;

  /// ユーザー進捗
  final UserProgress? userProgress;

  /// デイリーチャレンジ
  final DailyChallenge? dailyChallenge;

  /// 統計情報
  final Map<String, dynamic>? statistics;

  /// エラーメッセージ
  final String? errorMessage;

  const ProgressState({
    this.status = ProgressStatus.initial,
    this.userProgress,
    this.dailyChallenge,
    this.statistics,
    this.errorMessage,
  });

  /// コピーメソッド
  ProgressState copyWith({
    ProgressStatus? status,
    UserProgress? userProgress,
    DailyChallenge? dailyChallenge,
    Map<String, dynamic>? statistics,
    String? errorMessage,
  }) {
    return ProgressState(
      status: status ?? this.status,
      userProgress: userProgress ?? this.userProgress,
      dailyChallenge: dailyChallenge ?? this.dailyChallenge,
      statistics: statistics ?? this.statistics,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userProgress,
    dailyChallenge,
    statistics,
    errorMessage,
  ];
}
