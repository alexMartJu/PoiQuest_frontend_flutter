import 'package:dio/dio.dart';
import 'package:poiquest_frontend_flutter/core/utils/constants.dart';

/// Servicio centralizado para gestionar cliente HTTP.
/// 
/// Uso: `AppService.dio.get('/endpoint')`
class AppService {
  static final Dio dio = _buildDio();

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

    return d;
  }
}
