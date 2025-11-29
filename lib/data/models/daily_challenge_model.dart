import '../../domain/entities/daily_challenge.dart';

/// デイリーチャレンジモデル
class DailyChallengeModel {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final int targetValue;
  final int currentValue;
  final int rewardPoints;
  final DateTime date;
  final bool isCompleted;

  const DailyChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    required this.currentValue,
    required this.rewardPoints,
    required this.date,
    required this.isCompleted,
  });

  /// エンティティからモデルを作成
  factory DailyChallengeModel.fromEntity(DailyChallenge challenge) {
    return DailyChallengeModel(
      id: challenge.id,
      title: challenge.title,
      description: challenge.description,
      type: challenge.type,
      targetValue: challenge.targetValue,
      currentValue: challenge.currentValue,
      rewardPoints: challenge.rewardPoints,
      date: challenge.date,
      isCompleted: challenge.isCompleted,
    );
  }

  /// モデルをエンティティに変換
  DailyChallenge toEntity() {
    return DailyChallenge(
      id: id,
      title: title,
      description: description,
      type: type,
      targetValue: targetValue,
      currentValue: currentValue,
      rewardPoints: rewardPoints,
      date: date,
      isCompleted: isCompleted,
    );
  }

  /// JSONからモデルを作成
  factory DailyChallengeModel.fromJson(Map<String, dynamic> json) {
    return DailyChallengeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: ChallengeType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      targetValue: json['target_value'] as int,
      currentValue: json['current_value'] as int? ?? 0,
      rewardPoints: json['reward_points'] as int? ?? 10,
      date: json['date'] as DateTime,
      isCompleted: (json['is_completed'] as int?) == 1,
    );
  }

  /// モデルをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString(),
      'target_value': targetValue,
      'current_value': currentValue,
      'reward_points': rewardPoints,
      'is_completed': isCompleted ? 1 : 0,
    };
  }
}
