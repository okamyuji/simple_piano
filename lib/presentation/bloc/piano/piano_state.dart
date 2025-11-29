import 'package:equatable/equatable.dart';

import '../../../domain/entities/note.dart';

/// ピアノステート
class PianoState extends Equatable {
  /// 初期化状態
  final bool isInitialized;

  /// 現在押されている音符のリスト
  final List<Note> activeNotes;

  /// 現在のボリューム（0.0 - 1.0）
  final double volume;

  /// 現在のオクターブ
  final int currentOctave;

  /// ローディング状態
  final bool isLoading;

  /// エラーメッセージ
  final String? errorMessage;

  const PianoState({
    this.isInitialized = false,
    this.activeNotes = const [],
    this.volume = 0.7,
    this.currentOctave = 4,
    this.isLoading = false,
    this.errorMessage,
  });

  /// コピーメソッド
  PianoState copyWith({
    bool? isInitialized,
    List<Note>? activeNotes,
    double? volume,
    int? currentOctave,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PianoState(
      isInitialized: isInitialized ?? this.isInitialized,
      activeNotes: activeNotes ?? this.activeNotes,
      volume: volume ?? this.volume,
      currentOctave: currentOctave ?? this.currentOctave,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  /// エラーをクリア
  PianoState clearError() {
    return copyWith(errorMessage: null);
  }

  @override
  List<Object?> get props => [
    isInitialized,
    activeNotes,
    volume,
    currentOctave,
    isLoading,
    errorMessage,
  ];
}
