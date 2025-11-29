import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/repositories/recording_repository.dart';
import '../../../domain/usecases/start_recording.dart';
import '../../../domain/usecases/stop_recording.dart';
import 'recording_event.dart';
import 'recording_state.dart';

/// 録音BLoC
@injectable
class RecordingBloc extends Bloc<RecordingEvent, RecordingState> {
  final StartRecording startRecordingUseCase;
  final StopRecording stopRecordingUseCase;
  final RecordingRepository recordingRepository;

  RecordingBloc({
    required this.startRecordingUseCase,
    required this.stopRecordingUseCase,
    required this.recordingRepository,
  }) : super(const RecordingState()) {
    on<RecordingLoadAllEvent>(_onLoadAll);
    on<RecordingStartEvent>(_onStart);
    on<RecordingAddNoteEvent>(_onAddNote);
    on<RecordingStopEvent>(_onStop);
    on<RecordingCancelEvent>(_onCancel);
    on<RecordingPlayEvent>(_onPlay);
    on<RecordingStopPlaybackEvent>(_onStopPlayback);
    on<RecordingDeleteEvent>(_onDelete);
  }

  /// すべての録音を読み込み
  Future<void> _onLoadAll(
    RecordingLoadAllEvent event,
    Emitter<RecordingState> emit,
  ) async {
    emit(state.copyWith(status: RecordingStatus.loading));

    final result = await recordingRepository.getAllRecordings();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RecordingStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (recordings) => emit(
        state.copyWith(status: RecordingStatus.loaded, recordings: recordings),
      ),
    );
  }

  /// 録音を開始
  Future<void> _onStart(
    RecordingStartEvent event,
    Emitter<RecordingState> emit,
  ) async {
    final result = await startRecordingUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RecordingStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (recordingId) => emit(
        state.copyWith(
          status: RecordingStatus.recording,
          currentRecordingId: recordingId,
        ),
      ),
    );
  }

  /// 音符を追加
  Future<void> _onAddNote(
    RecordingAddNoteEvent event,
    Emitter<RecordingState> emit,
  ) async {
    if (state.currentRecordingId == null) {
      emit(
        state.copyWith(
          status: RecordingStatus.error,
          errorMessage: '録音が開始されていません',
        ),
      );
      return;
    }

    final result = await recordingRepository.addNoteToRecording(
      state.currentRecordingId!,
      event.note,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RecordingStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        // 状態は変更しない（録音中のまま）
      },
    );
  }

  /// 録音を停止
  Future<void> _onStop(
    RecordingStopEvent event,
    Emitter<RecordingState> emit,
  ) async {
    if (state.currentRecordingId == null) {
      emit(
        state.copyWith(
          status: RecordingStatus.error,
          errorMessage: '録音が開始されていません',
        ),
      );
      return;
    }

    final result = await stopRecordingUseCase(
      StopRecordingParams(
        recordingId: state.currentRecordingId!,
        name: event.name,
      ),
    );

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: RecordingStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (recording) async {
        emit(
          state.copyWith(
            status: RecordingStatus.stopped,
            currentRecordingId: null,
          ),
        );

        // 録音一覧を再読み込み
        add(const RecordingLoadAllEvent());
      },
    );
  }

  /// 録音をキャンセル
  Future<void> _onCancel(
    RecordingCancelEvent event,
    Emitter<RecordingState> emit,
  ) async {
    if (state.currentRecordingId == null) return;

    final result = await recordingRepository.cancelRecording(
      state.currentRecordingId!,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RecordingStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: RecordingStatus.stopped,
          currentRecordingId: null,
        ),
      ),
    );
  }

  /// 録音を再生
  Future<void> _onPlay(
    RecordingPlayEvent event,
    Emitter<RecordingState> emit,
  ) async {
    final result = await recordingRepository.playRecording(event.recording);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RecordingStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: RecordingStatus.playing,
          playingRecording: event.recording,
        ),
      ),
    );
  }

  /// 再生を停止
  Future<void> _onStopPlayback(
    RecordingStopPlaybackEvent event,
    Emitter<RecordingState> emit,
  ) async {
    final result = await recordingRepository.stopPlayback();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RecordingStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(status: RecordingStatus.stopped, playingRecording: null),
      ),
    );
  }

  /// 録音を削除
  Future<void> _onDelete(
    RecordingDeleteEvent event,
    Emitter<RecordingState> emit,
  ) async {
    final result = await recordingRepository.deleteRecording(event.recordingId);

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: RecordingStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) async {
        // 録音一覧を再読み込み
        add(const RecordingLoadAllEvent());
      },
    );
  }
}
