import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;

import '../../core/errors/failures.dart';
import '../../domain/entities/recording.dart';
import '../../domain/repositories/recording_repository.dart';
import '../datasources/local/database_helper.dart';
import '../models/recording_model.dart';

/// 録音リポジトリ実装
@LazySingleton(as: RecordingRepository)
class RecordingRepositoryImpl implements RecordingRepository {
  final DatabaseHelper databaseHelper;
  final Map<String, List<RecordedNote>> _activeRecordings = {};
  final Map<String, DateTime> _recordingStartTimes = {};

  RecordingRepositoryImpl(this.databaseHelper);

  @override
  Future<Either<Failure, String>> startRecording() async {
    try {
      final recordingId = 'recording_${DateTime.now().millisecondsSinceEpoch}';
      _activeRecordings[recordingId] = [];
      _recordingStartTimes[recordingId] = DateTime.now();
      return Right(recordingId);
    } catch (e) {
      return Left(RecordingFailure('録音の開始に失敗しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addNoteToRecording(
    String recordingId,
    RecordedNote note,
  ) async {
    try {
      if (!_activeRecordings.containsKey(recordingId)) {
        return const Left(RecordingFailure('録音が見つかりません'));
      }
      _activeRecordings[recordingId]!.add(note);
      return const Right(null);
    } catch (e) {
      return Left(RecordingFailure('音符の追加に失敗しました: $e'));
    }
  }

  @override
  Future<Either<Failure, Recording>> stopRecording(
    String recordingId,
    String name,
  ) async {
    try {
      if (!_activeRecordings.containsKey(recordingId)) {
        return const Left(RecordingFailure('録音が見つかりません'));
      }

      final notes = _activeRecordings[recordingId]!;
      final startTime = _recordingStartTimes[recordingId]!;
      final endTime = DateTime.now();
      final totalDuration = endTime.difference(startTime).inMilliseconds;

      final recording = Recording(
        id: recordingId,
        name: name,
        notes: notes,
        recordedAt: startTime,
        totalDuration: totalDuration,
      );

      // データベースに保存
      final db = await databaseHelper.database;
      final model = RecordingModel.fromEntity(recording);
      final map = model.toJson();
      map['recorded_at'] = recording.recordedAt.millisecondsSinceEpoch;
      map['notes'] = jsonEncode(
        notes
            .map(
              (n) => {
                'midiNumber': n.midiNumber,
                'startTime': n.startTime,
                'endTime': n.endTime,
                'velocity': n.velocity,
              },
            )
            .toList(),
      );

      await db.insert(
        'recordings',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // メモリから削除
      _activeRecordings.remove(recordingId);
      _recordingStartTimes.remove(recordingId);

      return Right(recording);
    } catch (e) {
      return Left(RecordingFailure('録音の停止に失敗しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelRecording(String recordingId) async {
    try {
      _activeRecordings.remove(recordingId);
      _recordingStartTimes.remove(recordingId);
      return const Right(null);
    } catch (e) {
      return Left(RecordingFailure('録音のキャンセルに失敗しました: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Recording>>> getAllRecordings() async {
    try {
      final db = await databaseHelper.database;
      final maps = await db.query('recordings', orderBy: 'recorded_at DESC');

      final recordings = maps.map((map) {
        final notesJson = jsonDecode(map['notes'] as String) as List;
        final notes = notesJson
            .map(
              (n) => RecordedNote(
                midiNumber: n['midiNumber'] as int,
                startTime: n['startTime'] as int,
                endTime: n['endTime'] as int,
                velocity: n['velocity'] as int,
              ),
            )
            .toList();

        return Recording(
          id: map['id'] as String,
          name: map['name'] as String,
          notes: notes,
          recordedAt: DateTime.fromMillisecondsSinceEpoch(
            map['recorded_at'] as int,
          ),
          totalDuration: map['total_duration'] as int,
          tempo: map['tempo'] as int,
          filePath: map['file_path'] as String?,
        );
      }).toList();

      return Right(recordings);
    } catch (e) {
      return Left(RecordingFailure('録音の取得に失敗しました: $e'));
    }
  }

  @override
  Future<Either<Failure, Recording>> getRecordingById(String id) async {
    try {
      final allRecordingsResult = await getAllRecordings();
      return allRecordingsResult.fold((failure) => Left(failure), (recordings) {
        try {
          final recording = recordings.firstWhere((r) => r.id == id);
          return Right(recording);
        } catch (e) {
          return const Left(RecordingFailure('録音が見つかりません'));
        }
      });
    } catch (e) {
      return Left(RecordingFailure('録音の取得に失敗しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> playRecording(Recording recording) async {
    try {
      // 録音の再生実装
      // 音符を順番に再生するロジック
      for (final note in recording.notes) {
        // 実際の音声再生は AudioEngine で実装
        // ここでは再生フラグのみ管理
        await Future.delayed(Duration(milliseconds: note.startTime));
      }
      return const Right(null);
    } catch (e) {
      return Left(RecordingFailure('録音の再生に失敗しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> stopPlayback() async {
    try {
      // 再生の停止実装
      // AudioEngine に停止を通知
      return const Right(null);
    } catch (e) {
      return Left(RecordingFailure('再生の停止に失敗しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecording(String id) async {
    try {
      final db = await databaseHelper.database;
      await db.delete('recordings', where: 'id = ?', whereArgs: [id]);
      return const Right(null);
    } catch (e) {
      return Left(RecordingFailure('録音の削除に失敗しました: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> exportRecording(
    String id,
    String format,
  ) async {
    try {
      final db = await databaseHelper.database;

      final recordings = await db.query(
        'recordings',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (recordings.isEmpty) {
        return Left(RecordingFailure('録音が見つかりません'));
      }

      final recordingData = recordings.first;
      final notesJson = recordingData['notes'] as String;
      final notes = (jsonDecode(notesJson) as List)
          .map((e) => RecordedNoteModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final exportData = {
        'id': recordingData['id'],
        'title': recordingData['title'],
        'createdAt': recordingData['createdAt'],
        'duration': recordingData['duration'],
        'notes': notes.map((n) => n.toJson()).toList(),
        'format': format,
      };

      return Right(jsonEncode(exportData));
    } catch (e) {
      return Left(RecordingFailure('録音のエクスポートに失敗しました: $e'));
    }
  }
}
