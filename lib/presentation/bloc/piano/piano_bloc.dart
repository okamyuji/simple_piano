import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/repositories/audio_repository.dart';
import '../../../domain/usecases/play_note.dart';
import '../../../domain/usecases/stop_note.dart';
import 'piano_event.dart';
import 'piano_state.dart';

/// ピアノBLoC
@injectable
class PianoBloc extends Bloc<PianoEvent, PianoState> {
  final PlayNote playNoteUseCase;
  final StopNote stopNoteUseCase;
  final AudioRepository audioRepository;

  PianoBloc({
    required this.playNoteUseCase,
    required this.stopNoteUseCase,
    required this.audioRepository,
  }) : super(const PianoState()) {
    on<PianoInitializeEvent>(_onInitialize);
    on<PianoKeyPressedEvent>(_onKeyPressed);
    on<PianoKeyReleasedEvent>(_onKeyReleased);
    on<PianoStopAllNotesEvent>(_onStopAllNotes);
    on<PianoVolumeChangedEvent>(_onVolumeChanged);
    on<PianoOctaveChangedEvent>(_onOctaveChanged);
    on<PianoDisposeEvent>(_onDispose);
  }

  /// 初期化処理
  Future<void> _onInitialize(
    PianoInitializeEvent event,
    Emitter<PianoState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await audioRepository.initialize();

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isInitialized: true, isLoading: false)),
    );
  }

  /// キー押下処理
  Future<void> _onKeyPressed(
    PianoKeyPressedEvent event,
    Emitter<PianoState> emit,
  ) async {
    if (!state.isInitialized) {
      emit(state.copyWith(errorMessage: 'ピアノが初期化されていません'));
      return;
    }

    final result = await playNoteUseCase(
      PlayNoteParams(note: event.note, volume: event.velocity * state.volume),
    );

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        // アクティブノートリストに追加
        final updatedActiveNotes = [...state.activeNotes];
        if (!updatedActiveNotes.contains(event.note)) {
          updatedActiveNotes.add(event.note);
        }
        emit(state.copyWith(activeNotes: updatedActiveNotes));
      },
    );
  }

  /// キーリリース処理
  Future<void> _onKeyReleased(
    PianoKeyReleasedEvent event,
    Emitter<PianoState> emit,
  ) async {
    if (!state.isInitialized) return;

    final result = await stopNoteUseCase(StopNoteParams(note: event.note));

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        // アクティブノートリストから削除
        final updatedActiveNotes = state.activeNotes
            .where((note) => note.midiNumber != event.note.midiNumber)
            .toList();
        emit(state.copyWith(activeNotes: updatedActiveNotes));
      },
    );
  }

  /// すべての音を停止
  Future<void> _onStopAllNotes(
    PianoStopAllNotesEvent event,
    Emitter<PianoState> emit,
  ) async {
    if (!state.isInitialized) return;

    final result = await audioRepository.stopAllNotes();

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => emit(state.copyWith(activeNotes: [])),
    );
  }

  /// ボリューム変更処理
  Future<void> _onVolumeChanged(
    PianoVolumeChangedEvent event,
    Emitter<PianoState> emit,
  ) async {
    final result = await audioRepository.setVolume(event.volume);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => emit(state.copyWith(volume: event.volume)),
    );
  }

  /// オクターブ変更処理
  Future<void> _onOctaveChanged(
    PianoOctaveChangedEvent event,
    Emitter<PianoState> emit,
  ) async {
    // ローディング状態にする
    emit(state.copyWith(isLoading: true));

    // 新しいオクターブ範囲のWAVファイルを事前生成
    final result = await audioRepository.preloadOctaveRange(event.octave, 2);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'オクターブ変更エラー: ${failure.message}',
        ),
      ),
      (_) =>
          emit(state.copyWith(currentOctave: event.octave, isLoading: false)),
    );
  }

  /// 破棄処理
  Future<void> _onDispose(
    PianoDisposeEvent event,
    Emitter<PianoState> emit,
  ) async {
    await audioRepository.dispose();
    emit(const PianoState());
  }
}
