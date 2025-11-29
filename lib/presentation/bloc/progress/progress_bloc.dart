import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/repositories/progress_repository.dart';
import '../../../domain/usecases/get_daily_challenge.dart';
import '../../../domain/usecases/get_user_progress.dart';
import '../../../domain/usecases/record_session.dart';
import '../../../domain/usecases/save_progress.dart';
import 'progress_event.dart';
import 'progress_state.dart';

/// 進捗BLoC
@injectable
class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final GetUserProgress getUserProgressUseCase;
  final SaveProgress saveProgressUseCase;
  final RecordSession recordSessionUseCase;
  final GetDailyChallenge getDailyChallengeUseCase;
  final ProgressRepository progressRepository;

  ProgressBloc({
    required this.getUserProgressUseCase,
    required this.saveProgressUseCase,
    required this.recordSessionUseCase,
    required this.getDailyChallengeUseCase,
    required this.progressRepository,
  }) : super(const ProgressState()) {
    on<ProgressLoadEvent>(_onLoad);
    on<ProgressSaveSessionEvent>(_onSaveSession);
    on<ProgressUpdateStreakEvent>(_onUpdateStreak);
    on<ProgressAddMilestoneEvent>(_onAddMilestone);
    on<ProgressLoadDailyChallengeEvent>(_onLoadDailyChallenge);
    on<ProgressUpdateChallengeEvent>(_onUpdateChallenge);
    on<ProgressCompleteChallengeEvent>(_onCompleteChallenge);
    on<ProgressLoadStatisticsEvent>(_onLoadStatistics);
  }

  /// 進捗を読み込み
  Future<void> _onLoad(
    ProgressLoadEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(state.copyWith(status: ProgressStatus.loading));

    final result = await getUserProgressUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProgressStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (progress) {
        debugPrint(
          '[ProgressBloc] 進捗読み込み完了: 完了レッスン数=${progress.completedLessons.length}',
        );
        emit(
          state.copyWith(status: ProgressStatus.loaded, userProgress: progress),
        );
      },
    );
  }

  /// 練習セッションを保存
  Future<void> _onSaveSession(
    ProgressSaveSessionEvent event,
    Emitter<ProgressState> emit,
  ) async {
    debugPrint('[ProgressBloc] セッション保存開始: ${event.session}');
    emit(state.copyWith(status: ProgressStatus.saving));

    final result = await recordSessionUseCase(
      RecordSessionParams(session: event.session),
    );

    await result.fold(
      (failure) async {
        debugPrint('[ProgressBloc] セッション保存失敗: ${failure.message}');
        emit(
          state.copyWith(
            status: ProgressStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) async {
        debugPrint('[ProgressBloc] セッション保存成功');

        // 進捗データを取得または作成
        var userProgress = state.userProgress;
        if (userProgress == null) {
          debugPrint('[ProgressBloc] UserProgressがnull、再読み込み');
          final progressResult = await getUserProgressUseCase();
          await progressResult.fold(
            (failure) async {
              debugPrint(
                '[ProgressBloc] UserProgress読み込み失敗: ${failure.message}',
              );
            },
            (progress) async {
              userProgress = progress;
            },
          );
        }

        if (userProgress != null) {
          // セッション保存後、進捗を更新
          final updatedProgress = userProgress!.copyWith(
            totalPracticeTime:
                userProgress!.totalPracticeTime + event.session.duration,
            totalNotesPlayed:
                userProgress!.totalNotesPlayed + event.session.notesPlayed,
            updatedAt: DateTime.now(),
          );

          debugPrint(
            '[ProgressBloc] 進捗更新: 練習時間=${updatedProgress.totalPracticeTime}秒, 音符数=${updatedProgress.totalNotesPlayed}',
          );

          final saveResult = await saveProgressUseCase(
            SaveProgressParams(progress: updatedProgress),
          );

          saveResult.fold(
            (failure) {
              debugPrint('[ProgressBloc] 進捗保存失敗: ${failure.message}');
              emit(
                state.copyWith(
                  status: ProgressStatus.error,
                  errorMessage: failure.message,
                ),
              );
            },
            (_) {
              debugPrint('[ProgressBloc] 進捗保存成功');
              emit(
                state.copyWith(
                  status: ProgressStatus.saved,
                  userProgress: updatedProgress,
                ),
              );
            },
          );
        } else {
          debugPrint('[ProgressBloc] UserProgressが取得できませんでした');
          emit(state.copyWith(status: ProgressStatus.saved));
        }
      },
    );
  }

  /// ストリークを更新
  Future<void> _onUpdateStreak(
    ProgressUpdateStreakEvent event,
    Emitter<ProgressState> emit,
  ) async {
    final result = await progressRepository.updateStreak();

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: ProgressStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) async {
        // 更新後の進捗を再読み込み
        add(const ProgressLoadEvent());
      },
    );
  }

  /// マイルストーンを追加
  Future<void> _onAddMilestone(
    ProgressAddMilestoneEvent event,
    Emitter<ProgressState> emit,
  ) async {
    final result = await progressRepository.addMilestone(event.milestone);

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: ProgressStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) async {
        // 更新後の進捗を再読み込み
        add(const ProgressLoadEvent());
      },
    );
  }

  /// デイリーチャレンジを読み込み
  Future<void> _onLoadDailyChallenge(
    ProgressLoadDailyChallengeEvent event,
    Emitter<ProgressState> emit,
  ) async {
    final result = await getDailyChallengeUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProgressStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (challenge) => emit(state.copyWith(dailyChallenge: challenge)),
    );
  }

  /// デイリーチャレンジの進捗を更新
  Future<void> _onUpdateChallenge(
    ProgressUpdateChallengeEvent event,
    Emitter<ProgressState> emit,
  ) async {
    final result = await progressRepository.updateChallengeProgress(
      event.challengeId,
      event.currentValue,
    );

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: ProgressStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) async {
        // 更新後のチャレンジを再読み込み
        add(const ProgressLoadDailyChallengeEvent());
      },
    );
  }

  /// デイリーチャレンジを完了
  Future<void> _onCompleteChallenge(
    ProgressCompleteChallengeEvent event,
    Emitter<ProgressState> emit,
  ) async {
    final result = await progressRepository.markChallengeComplete(
      event.challengeId,
    );

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: ProgressStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) async {
        // 更新後のチャレンジを再読み込み
        add(const ProgressLoadDailyChallengeEvent());
      },
    );
  }

  /// 統計情報を読み込み
  Future<void> _onLoadStatistics(
    ProgressLoadStatisticsEvent event,
    Emitter<ProgressState> emit,
  ) async {
    final result = await progressRepository.getStatistics();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProgressStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (stats) => emit(state.copyWith(statistics: stats)),
    );
  }
}
