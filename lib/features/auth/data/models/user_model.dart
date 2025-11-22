import 'package:poiquest_frontend_flutter/features/auth/domain/entities/user.dart';

/// Modelo de usuario para la capa de datos.
/// 
/// Extiende la entidad User y añade funcionalidad de serialización.
class UserModel extends User {
  const UserModel({
    required super.userId,
    required super.name,
    required super.lastname,
    required super.email,
    super.avatarUrl,
    super.bio,
    required super.roles,
  });

  /// Crea una instancia de UserModel desde JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as int,
      name: json['name'] as String? ?? '',
      lastname: json['lastname'] as String? ?? '',
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  /// Convierte la instancia a JSON.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'lastname': lastname,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'roles': roles,
    };
  }

  /// Convierte el modelo a la entidad del dominio.
  User toEntity() {
    return User(
      userId: userId,
      name: name,
      lastname: lastname,
      email: email,
      avatarUrl: avatarUrl,
      bio: bio,
      roles: roles,
    );
  }
}
