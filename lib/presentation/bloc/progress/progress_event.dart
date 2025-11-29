import 'package:equatable/equatable.dart';

import '../../../domain/entities/practice_session.dart';

/// 進捗イベント基底クラス
abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

/// 進捗読み込みイベント
class ProgressLoadEvent extends ProgressEvent {
  const ProgressLoadEvent();
}

/// 練習セッション保存イベント
class ProgressSaveSessionEvent extends ProgressEvent {
  final PracticeSession session;

  const ProgressSaveSessionEvent({required this.session});

  @override
  List<Object?> get props => [session];
}

/// ストリーク更新イベント
class ProgressUpdateStreakEvent extends ProgressEvent {
  const ProgressUpdateStreakEvent();
}

/// マイルストーン追加イベント
class ProgressAddMilestoneEvent extends ProgressEvent {
  final String milestone;

  const ProgressAddMilestoneEvent({required this.milestone});

  @override
  List<Object?> get props => [milestone];
}

/// デイリーチャレンジ読み込みイベント
class ProgressLoadDailyChallengeEvent extends ProgressEvent {
  const ProgressLoadDailyChallengeEvent();
}

/// デイリーチャレンジ進捗更新イベント
class ProgressUpdateChallengeEvent extends ProgressEvent {
  final String challengeId;
  final int currentValue;

  const ProgressUpdateChallengeEvent({
    required this.challengeId,
    required this.currentValue,
  });

  @override
  List<Object?> get props => [challengeId, currentValue];
}

/// デイリーチャレンジ完了イベント
class ProgressCompleteChallengeEvent extends ProgressEvent {
  final String challengeId;

  const ProgressCompleteChallengeEvent({required this.challengeId});

  @override
  List<Object?> get props => [challengeId];
}

/// 統計情報読み込みイベント
class ProgressLoadStatisticsEvent extends ProgressEvent {
  const ProgressLoadStatisticsEvent();
}
