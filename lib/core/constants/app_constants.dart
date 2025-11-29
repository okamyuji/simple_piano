/// アプリケーション定数
class AppConstants {
  AppConstants._();

  // ピアノ定数
  static const int totalKeys = 24; // 2オクターブ
  static const int startingOctave = 4; // C4から開始
  static const int whiteKeysPerOctave = 7;
  static const int blackKeysPerOctave = 5;
  static const int totalKeysPerOctave = 12;

  // 音符定数
  static const List<String> noteNames = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];

  static const List<String> whiteNoteNames = [
    'C',
    'D',
    'E',
    'F',
    'G',
    'A',
    'B',
  ];

  static const List<String> blackNoteNames = ['C#', 'D#', 'F#', 'G#', 'A#'];

  // メトロノーム定数
  static const int minBpm = 40;
  static const int maxBpm = 208;
  static const int defaultBpm = 120;

  // 練習セッション定数
  static const int minPracticeSeconds = 60; // 最小1分
  static const int dailyChallengeSeconds = 300; // 5分

  // レッスンレベル
  static const int totalLessons = 5;
  static const int lessonsPerLevel = 3;

  // 進捗関連
  static const int streakMilestones = 7; // 7日連続でマイルストーン
  static const int practiceTimeMilestones = 3600; // 1時間でマイルストーン

  // データベース
  static const String databaseName = 'simple_piano.db';
  static const int databaseVersion = 1;

  // SharedPreferences Keys
  static const String keyUserProgress = 'user_progress';
}
