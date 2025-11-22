import 'package:poiquest_frontend_flutter/features/auth/domain/entities/auth_tokens.dart';
import 'package:poiquest_frontend_flutter/features/auth/domain/entities/user.dart';

/// Repositorio abstracto de autenticación.
/// 
/// Define el contrato que debe implementar cualquier repositorio de autenticación.
abstract class AuthRepository {
  /// Inicia sesión con email y contraseña.
  /// 
  /// Retorna [AuthTokens] con los tokens de acceso y refresco.
  /// Lanza una excepción si las credenciales son incorrectas.
  Future<AuthTokens> login({
    required String email,
    required String password,
  });

  /// Registra un nuevo usuario estándar.
  /// 
  /// Retorna [AuthTokens] con los tokens de acceso y refresco del nuevo usuario.
  /// Lanza una excepción si el email ya está en uso.
  Future<AuthTokens> registerStandardUser({
    required String name,
    required String lastname,
    required String email,
    required String password,
    String? avatarUrl,
    String? bio,
  });

  /// Obtiene un nuevo access token usando el refresh token.
  /// 
  /// Retorna [AuthTokens] con el nuevo access token y el mismo refresh token.
  /// Lanza una excepción si el refresh token es inválido o ha expirado.
  Future<AuthTokens> refreshAccessToken();

  /// Cierra la sesión del dispositivo actual.
  /// 
  /// Invalida el refresh token actual en el servidor y limpia el almacenamiento local.
  Future<void> logout();

  /// Cierra todas las sesiones del usuario.
  /// 
  /// Invalida todos los refresh tokens del usuario en el servidor.
  Future<void> logoutAll();

  /// Obtiene los datos del usuario autenticado actual.
  /// 
  /// Retorna [User] con los datos del perfil del usuario.
  /// Lanza una excepción si no hay sesión activa.
  Future<User> getCurrentUser();

  /// Lee el token de acceso del almacenamiento seguro.
  /// 
  /// Retorna el token de acceso o null si no existe.
  Future<String?> readToken();

  /// Lee el refresh token del almacenamiento seguro.
  /// 
  /// Retorna el refresh token o null si no existe.
  Future<String?> readRefreshToken();
}
