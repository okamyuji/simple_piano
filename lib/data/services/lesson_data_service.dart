import 'package:injectable/injectable.dart';

import '../../domain/entities/lesson.dart';

/// レッスンデータサービス（静的レッスンデータを提供）
@lazySingleton
class LessonDataService {
  /// すべてのレッスンデータを取得
  List<Lesson> getAllLessons() {
    return [
      // Level 1: 単音認識
      const Lesson(
        id: 'lesson_1_1',
        title: 'ドレミを覚えよう',
        description: '基本の3音（ド・レ・ミ）を認識して弾く練習です。',
        difficulty: LessonDifficulty.beginner,
        type: LessonType.noteRecognition,
        level: 1,
        order: 1,
        practiceNotes: [60, 62, 64], // C4, D4, E4
        targetAccuracy: 80,
        recommendedDuration: 180,
      ),
      const Lesson(
        id: 'lesson_1_2',
        title: 'ファソラシを覚えよう',
        description: '次の4音（ファ・ソ・ラ・シ）を認識して弾く練習です。',
        difficulty: LessonDifficulty.beginner,
        type: LessonType.noteRecognition,
        level: 1,
        order: 2,
        practiceNotes: [65, 67, 69, 71], // F4, G4, A4, B4
        targetAccuracy: 80,
        recommendedDuration: 180,
      ),
      const Lesson(
        id: 'lesson_1_3',
        title: '1オクターブ完成',
        description: 'ドからドまでの1オクターブを完璧にマスターしましょう。',
        difficulty: LessonDifficulty.beginner,
        type: LessonType.noteRecognition,
        level: 1,
        order: 3,
        practiceNotes: [60, 62, 64, 65, 67, 69, 71, 72], // C4-C5
        targetAccuracy: 85,
        recommendedDuration: 240,
      ),

      // Level 2: 簡単なメロディ
      const Lesson(
        id: 'lesson_2_1',
        title: 'きらきら星（前半）',
        description: '誰もが知っている「きらきら星」の前半部分を弾きましょう。',
        difficulty: LessonDifficulty.elementary,
        type: LessonType.melody,
        level: 2,
        order: 4,
        practiceNotes: [60, 60, 67, 67, 69, 69, 67], // ドドソソララソ
        targetAccuracy: 80,
        recommendedDuration: 300,
      ),
      const Lesson(
        id: 'lesson_2_2',
        title: 'きらきら星（完成）',
        description: '「きらきら星」の全体を通して弾けるようにしましょう。',
        difficulty: LessonDifficulty.elementary,
        type: LessonType.melody,
        level: 2,
        order: 5,
        practiceNotes: [60, 60, 67, 67, 69, 69, 67, 65, 65, 64, 64, 62, 62, 60],
        targetAccuracy: 85,
        recommendedDuration: 360,
      ),
      const Lesson(
        id: 'lesson_2_3',
        title: 'チューリップ',
        description: '春の歌「チューリップ」を弾いてみましょう。',
        difficulty: LessonDifficulty.elementary,
        type: LessonType.melody,
        level: 2,
        order: 6,
        practiceNotes: [64, 62, 60, 62, 64, 64, 64], // ミレドレミミミ
        targetAccuracy: 85,
        recommendedDuration: 300,
      ),

      // Level 3: 両手練習基礎
      const Lesson(
        id: 'lesson_3_1',
        title: '両手で同じ音',
        description: '左右の手で同時に同じ音を弾く練習です。',
        difficulty: LessonDifficulty.intermediate,
        type: LessonType.twoHands,
        level: 3,
        order: 7,
        practiceNotes: [60, 62, 64, 65, 67], // C4-G4
        targetAccuracy: 80,
        recommendedDuration: 300,
      ),
      const Lesson(
        id: 'lesson_3_2',
        title: '交互に弾く',
        description: '左右の手を交互に使って弾く練習です。',
        difficulty: LessonDifficulty.intermediate,
        type: LessonType.twoHands,
        level: 3,
        order: 8,
        practiceNotes: [60, 62, 64, 65, 67, 69, 71, 72],
        targetAccuracy: 85,
        recommendedDuration: 360,
      ),
      const Lesson(
        id: 'lesson_3_3',
        title: '簡単な和音',
        description: '2つの音を同時に弾く練習です。',
        difficulty: LessonDifficulty.intermediate,
        type: LessonType.twoHands,
        level: 3,
        order: 9,
        practiceNotes: [60, 64, 67], // C, E, G (Cメジャーコード)
        targetAccuracy: 85,
        recommendedDuration: 300,
      ),

      // Level 4: リズムパターン
      const Lesson(
        id: 'lesson_4_1',
        title: '4分音符のリズム',
        description: '一定のリズムで音符を弾く練習です。',
        difficulty: LessonDifficulty.advanced,
        type: LessonType.rhythm,
        level: 4,
        order: 10,
        practiceNotes: [60, 62, 64, 65, 67, 69, 71, 72],
        targetAccuracy: 85,
        recommendedDuration: 300,
      ),
      const Lesson(
        id: 'lesson_4_2',
        title: '8分音符のリズム',
        description: '速いリズムで音符を弾く練習です。',
        difficulty: LessonDifficulty.advanced,
        type: LessonType.rhythm,
        level: 4,
        order: 11,
        practiceNotes: [60, 62, 64, 65, 67, 69, 71, 72],
        targetAccuracy: 85,
        recommendedDuration: 360,
      ),
      const Lesson(
        id: 'lesson_4_3',
        title: 'リズムの組み合わせ',
        description: '異なるリズムを組み合わせて弾く練習です。',
        difficulty: LessonDifficulty.advanced,
        type: LessonType.rhythm,
        level: 4,
        order: 12,
        practiceNotes: [60, 62, 64, 65, 67, 69, 71, 72],
        targetAccuracy: 90,
        recommendedDuration: 420,
      ),

      // Level 5: 曲の完成
      const Lesson(
        id: 'lesson_5_1',
        title: 'かえるの歌',
        description: '輪唱で有名な「かえるの歌」を完璧に弾きましょう。',
        difficulty: LessonDifficulty.expert,
        type: LessonType.song,
        level: 5,
        order: 13,
        practiceNotes: [60, 62, 64, 65, 64, 62, 60], // ドレミファミレド
        targetAccuracy: 90,
        recommendedDuration: 420,
      ),
      const Lesson(
        id: 'lesson_5_2',
        title: 'ちょうちょう',
        description: '春の歌「ちょうちょう」を両手で弾きましょう。',
        difficulty: LessonDifficulty.expert,
        type: LessonType.song,
        level: 5,
        order: 14,
        practiceNotes: [67, 64, 64, 65, 62, 62, 60, 62, 64, 65, 67, 67, 67],
        targetAccuracy: 90,
        recommendedDuration: 480,
      ),
      const Lesson(
        id: 'lesson_5_3',
        title: 'メリーさんの羊',
        description: '世界中で愛される「メリーさんの羊」を完成させましょう。',
        difficulty: LessonDifficulty.expert,
        type: LessonType.song,
        level: 5,
        order: 15,
        practiceNotes: [64, 62, 60, 62, 64, 64, 64, 62, 62, 62, 64, 67, 67],
        targetAccuracy: 90,
        recommendedDuration: 480,
      ),
    ];
  }

  /// レベル別にレッスンを取得
  List<Lesson> getLessonsByLevel(int level) {
    return getAllLessons().where((lesson) => lesson.level == level).toList();
  }

  /// IDでレッスンを取得
  Lesson? getLessonById(String id) {
    try {
      return getAllLessons().firstWhere((lesson) => lesson.id == id);
    } catch (e) {
      return null;
    }
  }
}
