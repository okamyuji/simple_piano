import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart' as app_exceptions;

/// データベースヘルパー
@lazySingleton
class DatabaseHelper {
  static Database? _database;

  /// データベースインスタンスを取得
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// データベースを初期化
  Future<Database> _initDatabase() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, AppConstants.databaseName);

      return await openDatabase(
        path,
        version: AppConstants.databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      throw app_exceptions.DatabaseException('データベースの初期化に失敗しました: $e');
    }
  }

  /// データベーステーブルを作成
  Future<void> _onCreate(Database db, int version) async {
    try {
      // 練習セッションテーブル
      await db.execute('''
        CREATE TABLE practice_sessions (
          id TEXT PRIMARY KEY,
          lesson_id TEXT,
          start_time INTEGER NOT NULL,
          end_time INTEGER,
          duration INTEGER NOT NULL DEFAULT 0,
          notes_played INTEGER NOT NULL DEFAULT 0,
          correct_notes INTEGER,
          accuracy REAL,
          recording_path TEXT,
          notes TEXT
        )
      ''');

      // レッスン進捗テーブル
      await db.execute('''
        CREATE TABLE lesson_progress (
          lesson_id TEXT PRIMARY KEY,
          is_completed INTEGER NOT NULL DEFAULT 0,
          best_accuracy INTEGER NOT NULL DEFAULT 0,
          attempts INTEGER NOT NULL DEFAULT 0,
          last_practiced INTEGER
        )
      ''');

      // 録音テーブル
      await db.execute('''
        CREATE TABLE recordings (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          notes TEXT NOT NULL,
          recorded_at INTEGER NOT NULL,
          total_duration INTEGER NOT NULL,
          tempo INTEGER NOT NULL DEFAULT 120,
          file_path TEXT
        )
      ''');

      // デイリーチャレンジテーブル
      await db.execute('''
        CREATE TABLE daily_challenges (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          type TEXT NOT NULL,
          target_value INTEGER NOT NULL,
          current_value INTEGER NOT NULL DEFAULT 0,
          reward_points INTEGER NOT NULL DEFAULT 10,
          date INTEGER NOT NULL,
          is_completed INTEGER NOT NULL DEFAULT 0
        )
      ''');
    } catch (e) {
      throw app_exceptions.DatabaseException('テーブルの作成に失敗しました: $e');
    }
  }

  /// データベースをアップグレード
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 将来のバージョンアップ時に実装
  }

  /// データベースを閉じる
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// データベースを削除
  Future<void> deleteDatabase() async {
    try {
      // データベースを閉じる
      if (_database != null) {
        await _database!.close();
        _database = null;
      }

      // データベースファイルを削除
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, AppConstants.databaseName);
      await databaseFactory.deleteDatabase(path);
    } catch (e) {
      throw app_exceptions.DatabaseException('データベースの削除に失敗しました: $e');
    }
  }
}
