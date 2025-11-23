import 'package:poiquest_frontend_flutter/features/profile/domain/entities/profile.dart';

/// Modelo de perfil para serialización/deserialización.
class ProfileModel {
  final String uuid;
  final String? name;
  final String? lastname;
  final String? avatarUrl;
  final String? bio;
  final int totalPoints;
  final int level;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileModel({
    required this.uuid,
    this.name,
    this.lastname,
    this.avatarUrl,
    this.bio,
    required this.totalPoints,
    required this.level,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Crea un ProfileModel desde JSON.
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      uuid: json['uuid'] as String,
      name: json['name'] as String?,
      lastname: json['lastname'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      totalPoints: json['totalPoints'] as int,
      level: json['level'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convierte el ProfileModel a JSON.
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'lastname': lastname,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'totalPoints': totalPoints,
      'level': level,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Convierte el ProfileModel a Profile entity.
  Profile toEntity() {
    return Profile(
      uuid: uuid,
      name: name,
      lastname: lastname,
      avatarUrl: avatarUrl,
      bio: bio,
      totalPoints: totalPoints,
      level: level,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
