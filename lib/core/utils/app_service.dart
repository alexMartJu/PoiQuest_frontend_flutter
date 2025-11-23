import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:poiquest_frontend_flutter/core/utils/constants.dart';

/// Servicio centralizado para gestionar cliente HTTP y almacenamiento seguro.
///
/// Uso:
/// - HTTP: `AppService.dio.get('/endpoint')`
/// - Storage: `AppService.storage.write(key: 'key', value: 'value')`
class AppService {
  /// Instancia única de FlutterSecureStorage para toda la app
  static final FlutterSecureStorage storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Callback opcional que se ejecuta cuando la sesión expira (tokens limpiados)
  /// Permite notificar al estado de autenticación para cerrar sesión en UI.
  static Future<void> Function()? onSessionExpired;

  /// Cliente HTTP configurado con interceptores de tokens y refresh
  static final Dio dio = _buildDio();

  /// Flag para evitar múltiples refreshes simultáneos
  static bool _isRefreshing = false;

  /// Cola de peticiones que esperan el refresh
  static final List<_RetryRequest> _requestsQueue = [];

  static Dio _buildDio() {
    final d = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (s) => s != null && s >= 200 && s < 300,
      ),
    );

    // Interceptor 1: Añadir el token de autorización automáticamente
    d.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // No añadir token a las peticiones de auth (login, register, refresh)
          final isAuthEndpoint = options.path.contains('/auth/login') ||
              options.path.contains('/auth/register') ||
              options.path.contains('/auth/refresh');

          if (!isAuthEndpoint) {
            final token = await storage.read(key: tokenKey);
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          handler.next(options);
        },
      ),
    );

    // Interceptor 2: Manejar errores 401 y refrescar token automáticamente
    d.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          // Si es un 401 y no es el endpoint de refresh ni login
          if (error.response?.statusCode == 401 &&
              !error.requestOptions.path.contains('/auth/refresh') &&
              !error.requestOptions.path.contains('/auth/login') &&
              !error.requestOptions.path.contains('/auth/change-password')) {

            // Si ya estamos refrescando, añadir a la cola
            if (_isRefreshing) {
              _requestsQueue.add(_RetryRequest(error.requestOptions, handler));
              return;
            }

            _isRefreshing = true;

            try {
              // Intentar refrescar el token
              final refreshToken = await storage.read(key: refreshKey);
              if (refreshToken == null || refreshToken.isEmpty) {
                // No hay refresh token, limpiar y notificar
                await _clearTokensAndQueue();
                _isRefreshing = false;
                return handler.next(error);
              }

              // Petición de refresh
              final response = await d.post(
                refreshTokenEndpoint,
                data: {'refreshToken': refreshToken},
              );

              if (response.statusCode == 200) {
                final newAccessToken = response.data['accessToken'] as String?;
                if (newAccessToken != null) {
                  await storage.write(key: tokenKey, value: newAccessToken);

                  // Reintentar la petición original con el nuevo token
                  final options = error.requestOptions;
                  options.headers['Authorization'] = 'Bearer $newAccessToken';

                  final retryResponse = await d.fetch(options);

                  // Procesar la cola de peticiones pendientes
                  await _processQueue(d, newAccessToken);

                  _isRefreshing = false;
                  return handler.resolve(retryResponse);
                }
              }

              // Si el refresh no devolvió token válido
              await _clearTokensAndQueue();
              _isRefreshing = false;
              return handler.next(error);
            } catch (_) {
              // En caso de error al refrescar, limpiar y continuar
              await _clearTokensAndQueue();
              _isRefreshing = false;
              return handler.next(error);
            }
          }

          handler.next(error);
        },
      ),
    );

    return d;
  }

  /// Procesa todas las peticiones en cola con el nuevo token
  static Future<void> _processQueue(Dio dio, String newToken) async {
    for (final retryRequest in _requestsQueue) {
      try {
        retryRequest.options.headers['Authorization'] = 'Bearer $newToken';
        final response = await dio.fetch(retryRequest.options);
        retryRequest.handler.resolve(response);
      } catch (e) {
        retryRequest.handler.reject(
          DioException(
            requestOptions: retryRequest.options,
            error: e,
          ),
        );
      }
    }
    _requestsQueue.clear();
  }

  /// Limpia los tokens y rechaza todas las peticiones en cola
  static Future<void> _clearTokensAndQueue() async {
    await storage.delete(key: tokenKey);
    await storage.delete(key: refreshKey);

    for (final retryRequest in _requestsQueue) {
      retryRequest.handler.reject(
        DioException(
          requestOptions: retryRequest.options,
          error: 'Session expired. Please login again.',
        ),
      );
    }
    _requestsQueue.clear();

    // Notificar al resto de la app que la sesión expiró
    if (onSessionExpired != null) {
      try {
        await onSessionExpired!();
      } catch (_) {
        // Ignorar errores del callback para no romper el flujo de interceptores
      }
    }
  }
}

/// Clase auxiliar para almacenar peticiones que esperan el refresh
class _RetryRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  _RetryRequest(this.options, this.handler);
}
