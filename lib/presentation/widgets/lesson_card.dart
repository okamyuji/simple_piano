import 'package:flutter/material.dart';

import '../../domain/entities/lesson.dart';

/// レッスンカードウィジェット
class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  const LessonCard({super.key, required this.lesson, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: lesson.isLocked ? 1 : 2,
      child: InkWell(
        onTap: lesson.isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // レッスンアイコン
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(
                        lesson.difficulty,
                      ).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getLessonIcon(lesson.type),
                      color: _getDifficultyColor(lesson.difficulty),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // タイトルとレベル
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: lesson.isLocked ? Colors.grey : null,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildDifficultyChip(context, lesson.difficulty),
                            const SizedBox(width: 8),
                            Text(
                              'レベル ${lesson.level}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // ステータスアイコン
                  if (lesson.isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 32,
                    )
                  else if (lesson.isLocked)
                    const Icon(Icons.lock, color: Colors.grey, size: 32),
                ],
              ),
              const SizedBox(height: 12),
              // 説明
              Text(
                lesson.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: lesson.isLocked ? Colors.grey : null,
                ),
              ),
              const SizedBox(height: 12),
              // 詳細情報
              Row(
                children: [
                  Icon(Icons.music_note, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${lesson.practiceNotes.length}音',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '約${lesson.recommendedDuration ~/ 60}分',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.track_changes, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '目標${lesson.targetAccuracy}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 難易度チップを構築
  Widget _buildDifficultyChip(
    BuildContext context,
    LessonDifficulty difficulty,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getDifficultyColor(difficulty).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getDifficultyText(difficulty),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: _getDifficultyColor(difficulty),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 難易度テキストを取得
  String _getDifficultyText(LessonDifficulty difficulty) {
    switch (difficulty) {
      case LessonDifficulty.beginner:
        return '入門';
      case LessonDifficulty.elementary:
        return '初級';
      case LessonDifficulty.intermediate:
        return '中級';
      case LessonDifficulty.advanced:
        return '上級';
      case LessonDifficulty.expert:
        return '達人';
    }
  }

  /// 難易度カラーを取得
  Color _getDifficultyColor(LessonDifficulty difficulty) {
    switch (difficulty) {
      case LessonDifficulty.beginner:
        return Colors.green;
      case LessonDifficulty.elementary:
        return Colors.blue;
      case LessonDifficulty.intermediate:
        return Colors.orange;
      case LessonDifficulty.advanced:
        return Colors.red;
      case LessonDifficulty.expert:
        return Colors.purple;
    }
  }

  /// レッスンアイコンを取得
  IconData _getLessonIcon(LessonType type) {
    switch (type) {
      case LessonType.noteRecognition:
        return Icons.music_note;
      case LessonType.melody:
        return Icons.queue_music;
      case LessonType.twoHands:
        return Icons.pan_tool;
      case LessonType.rhythm:
        return Icons.graphic_eq;
      case LessonType.song:
        return Icons.library_music;
    }
  }
}
