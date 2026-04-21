import 'package:poiquest_frontend_flutter/features/gamification/domain/entities/level_info.dart';

class LevelInfoModel {
  final int level;
  final String title;
  final int minPoints;
  final int discount;
  final String? reward;

  const LevelInfoModel({
    required this.level,
    required this.title,
    required this.minPoints,
    required this.discount,
    this.reward,
  });

  factory LevelInfoModel.fromJson(Map<String, dynamic> json) {
    return LevelInfoModel(
      level: json['level'] as int,
      title: json['title'] as String,
      minPoints: json['minPoints'] as int,
      discount: json['discount'] as int,
      reward: json['reward'] as String?,
    );
  }

  LevelInfo toEntity() {
    return LevelInfo(
      level: level,
      title: title,
      minPoints: minPoints,
      discount: discount,
      reward: reward,
    );
  }
}
