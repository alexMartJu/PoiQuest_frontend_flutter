import 'package:dio/dio.dart';
import 'package:poiquest_frontend_flutter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:poiquest_frontend_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:poiquest_frontend_flutter/features/auth/data/models/login_request.dart';
import 'package:poiquest_frontend_flutter/features/auth/data/models/logout_request.dart';
import 'package:poiquest_frontend_flutter/features/auth/data/models/refresh_token_request.dart';
import 'package:poiquest_frontend_flutter/features/auth/data/models/register_standard_user_request.dart';
import 'package:poiquest_frontend_flutter/features/auth/domain/entities/auth_tokens.dart';
import 'package:poiquest_frontend_flutter/features/auth/domain/entities/user.dart';
import 'package:poiquest_frontend_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Implementación del repositorio de autenticación.
/// 
/// Gestiona la autenticación usando el data source remoto y el almacenamiento seguro.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    AuthRemoteDataSource? remoteDataSource,
    AuthLocalDataSource? localDataSource,
  })  : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSource(),
        _localDataSource = localDataSource ?? AuthLocalDataSource();

  @override
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _remoteDataSource.login(request);
      // Guardar tokens en el almacenamiento seguro
      if (response.accessToken != null) {
        await _localDataSource.saveAccessToken(response.accessToken!);
      }
      if (response.refreshToken != null) {
        await _localDataSource.saveRefreshToken(response.refreshToken!);
      }
      return AuthTokens(
        accessToken: response.accessToken ?? '',
        refreshToken: response.refreshToken ?? '',
      );
    } catch (e) {
      // Si la excepción original es DioException, relanzarla para que la UI
      // pueda inspeccionar el `response?.statusCode` y mostrar mensajes
      // adecuados (por ejemplo 401 -> credenciales inválidas).
      if (e is DioException) rethrow;
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  @override
  Future<AuthTokens> registerStandardUser({
    required String name,
    required String lastname,
    required String email,
    required String password,
    String? avatarUrl,
    String? bio,
  }) async {
    try {
      final request = RegisterStandardUserRequest(
        name: name,
        lastname: lastname,
        email: email,
        password: password,
        avatarUrl: avatarUrl,
        bio: bio,
      );
      final response = await _remoteDataSource.registerStandardUser(request);

      // El endpoint de registro no devuelve tokens en vuestro backend,
      // por lo que no persistimos tokens aquí. Mantener el login como
      // único responsable de guardar tokens.

      return AuthTokens(
        accessToken: response.accessToken ?? '',
        refreshToken: response.refreshToken ?? '',
      );
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }

  @override
  Future<AuthTokens> refreshAccessToken() async {
    try {
      // Leer el refresh token del almacenamiento
      final refreshToken = await _localDataSource.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        throw Exception('No hay refresh token disponible');
      }

      final request = RefreshTokenRequest(refreshToken: refreshToken);
      final response = await _remoteDataSource.refreshAccessToken(request);

      // Guardar el nuevo access token
      if (response.accessToken != null) {
        await _localDataSource.saveAccessToken(response.accessToken!);
      }

      // El refresh token se mantiene igual según tu backend
      return AuthTokens(
        accessToken: response.accessToken ?? '',
        refreshToken: refreshToken,
      );
    } catch (e) {
      throw Exception('Error al refrescar token: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Leer el refresh token
      final refreshToken = await _localDataSource.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final request = LogoutRequest(refreshToken: refreshToken);
        await _remoteDataSource.logout(request);
      }

      // Limpiar tokens del almacenamiento
      await _localDataSource.clearTokens();
    } catch (e) {
      // Siempre limpiamos el almacenamiento local aunque falle la petición
      await _localDataSource.clearTokens();
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  @override
  Future<void> logoutAll() async {
    try {
      await _remoteDataSource.logoutAll();

      // Limpiar tokens del almacenamiento
      await _localDataSource.clearTokens();
    } catch (e) {
      // Siempre limpiamos el almacenamiento local aunque falle la petición
      await _localDataSource.clearTokens();
      throw Exception('Error al cerrar todas las sesiones: $e');
    }
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      final response = await _remoteDataSource.getCurrentUser();
      return response.user.toEntity();
    } catch (e) {
      throw Exception('Error al obtener usuario actual: $e');
    }
  }

  @override
  Future<String?> readToken() async {
    return await _localDataSource.getAccessToken();
  }

  @override
  Future<String?> readRefreshToken() async {
    return await _localDataSource.getRefreshToken();
  }
}
