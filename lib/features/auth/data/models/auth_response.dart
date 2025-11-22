import 'package:poiquest_frontend_flutter/features/auth/data/models/user_model.dart';

/// Modelo de respuesta de autenticación.
/// 
/// Representa la respuesta del servidor que incluye tokens y datos del usuario.
class AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final UserModel user;

  const AuthResponse({
    this.accessToken,
    this.refreshToken,
    required this.user,
  });

  /// Crea una instancia desde JSON.
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      user: UserModel.fromJson(json),
    );
  }

  /// Convierte a JSON.
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      ...user.toJson(),
    };
  }
}
