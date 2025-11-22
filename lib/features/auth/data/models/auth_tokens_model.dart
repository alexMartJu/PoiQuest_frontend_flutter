import 'package:poiquest_frontend_flutter/features/auth/domain/entities/auth_tokens.dart';

/// Modelo de tokens de autenticación para la capa de datos.
class AuthTokensModel extends AuthTokens {
  const AuthTokensModel({
    required super.accessToken,
    required super.refreshToken,
  });

  /// Crea una instancia desde JSON.
  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  /// Convierte a JSON.
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  /// Convierte el modelo a la entidad del dominio.
  AuthTokens toEntity() {
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
