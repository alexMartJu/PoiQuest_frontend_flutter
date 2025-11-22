import 'package:poiquest_frontend_flutter/core/utils/app_service.dart';
import 'package:poiquest_frontend_flutter/core/utils/constants.dart';
import 'package:poiquest_frontend_flutter/features/auth/data/models/auth_response.dart';
import 'package:poiquest_frontend_flutter/features/auth/data/models/login_request.dart';
import 'package:poiquest_frontend_flutter/features/auth/data/models/logout_request.dart';
import 'package:poiquest_frontend_flutter/features/auth/data/models/refresh_token_request.dart';
import 'package:poiquest_frontend_flutter/features/auth/data/models/register_standard_user_request.dart';

/// Fuente de datos remota para autenticación.
/// 
/// Maneja todas las peticiones HTTP relacionadas con autenticación usando Dio.
class AuthRemoteDataSource {
  /// Cliente HTTP de la aplicación.
  final _dio = AppService.dio;

  /// Inicia sesión con credenciales.
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      loginEndpoint,
      data: request.toJson(),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al iniciar sesión: ${response.statusMessage}');
    }
  }

  /// Registra un nuevo usuario estándar.
  Future<AuthResponse> registerStandardUser(
    RegisterStandardUserRequest request,
  ) async {
    final response = await _dio.post(
      registerStandardUserEndpoint,
      data: request.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al registrar usuario: ${response.statusMessage}');
    }
  }

  /// Refresca el access token.
  Future<AuthResponse> refreshAccessToken(
    RefreshTokenRequest request,
  ) async {
    final response = await _dio.post(
      refreshTokenEndpoint,
      data: request.toJson(),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al refrescar token: ${response.statusMessage}');
    }
  }

  /// Cierra la sesión del dispositivo actual.
  Future<void> logout(LogoutRequest request) async {
    final response = await _dio.post(
      logoutEndpoint,
      data: request.toJson(),
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Error al cerrar sesión: ${response.statusMessage}');
    }
  }

  /// Cierra todas las sesiones del usuario.
  Future<void> logoutAll() async {
    final response = await _dio.post(logoutAllEndpoint);

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception(
        'Error al cerrar todas las sesiones: ${response.statusMessage}',
      );
    }
  }

  /// Obtiene los datos del usuario actual.
  Future<AuthResponse> getCurrentUser() async {
    final response = await _dio.get(meEndpoint);

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception(
        'Error al obtener usuario actual: ${response.statusMessage}',
      );
    }
  }
}
