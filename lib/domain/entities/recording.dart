import 'package:equatable/equatable.dart';

/// 録音された音符情報
class RecordedNote extends Equatable {
  /// MIDIノート番号
  final int midiNumber;

  /// 開始時刻（ミリ秒）
  final int startTime;

  /// 終了時刻（ミリ秒）
  final int endTime;

  /// ベロシティ（音の強さ: 0-127）
  final int velocity;

  const RecordedNote({
    required this.midiNumber,
    required this.startTime,
    required this.endTime,
    this.velocity = 64,
  });

  @override
  List<Object?> get props => [midiNumber, startTime, endTime, velocity];

  /// 音符の長さ（ミリ秒）
  int get duration => endTime - startTime;
}

/// 録音エンティティ
class Recording extends Equatable {
  /// 録音ID
  final String id;

  /// 録音名
  final String name;

  /// 録音された音符のリスト
  final List<RecordedNote> notes;

  /// 録音日時
  final DateTime recordedAt;

  /// 総時間（ミリ秒）
  final int totalDuration;

  /// テンポ（BPM）
  final int tempo;

  /// ファイルパス（オプション）
  final String? filePath;

  const Recording({
    required this.id,
    required this.name,
    required this.notes,
    required this.recordedAt,
    required this.totalDuration,
    this.tempo = 120,
    this.filePath,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    notes,
    recordedAt,
    totalDuration,
    tempo,
    filePath,
  ];

  /// コピーメソッド
  Recording copyWith({
    String? id,
    String? name,
    List<RecordedNote>? notes,
    DateTime? recordedAt,
    int? totalDuration,
    int? tempo,
    String? filePath,
  }) {
    return Recording(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      recordedAt: recordedAt ?? this.recordedAt,
      totalDuration: totalDuration ?? this.totalDuration,
      tempo: tempo ?? this.tempo,
      filePath: filePath ?? this.filePath,
    );
  }

  /// 録音が空かどうか
  bool get isEmpty => notes.isEmpty;

  /// 録音された音符の数
  int get noteCount => notes.length;
}
