import 'package:poiquest_frontend_flutter/core/utils/app_service.dart';
import 'package:poiquest_frontend_flutter/core/utils/constants.dart';

/// DataSource local para operaciones de almacenamiento de tokens.
/// 
/// Encapsula el acceso al almacenamiento seguro de tokens de autenticación.
class AuthLocalDataSource {
  /// Obtiene el accessToken guardado en secure storage.
  Future<String?> getAccessToken() async {
    return await AppService.storage.read(key: tokenKey);
  }

  /// Obtiene el refreshToken guardado en secure storage.
  Future<String?> getRefreshToken() async {
    return await AppService.storage.read(key: refreshKey);
  }

  /// Guarda el accessToken en secure storage.
  Future<void> saveAccessToken(String token) async {
    await AppService.storage.write(key: tokenKey, value: token);
  }

  /// Guarda el refreshToken en secure storage.
  Future<void> saveRefreshToken(String token) async {
    await AppService.storage.write(key: refreshKey, value: token);
  }

  /// Elimina todos los tokens desde secure storage.
  Future<void> clearTokens() async {
    await AppService.storage.delete(key: tokenKey);
    await AppService.storage.delete(key: refreshKey);
  }
}
