import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Configuración de variables de entorno y helpers de URL.
/// 
/// Uso:
/// Debug local web/iOS:
///   flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
/// Debug Android emulator:
///   flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:8000
/// Debug Android Genymotion:
///   flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.3.2:8000
/// En build:
///   flutter build apk --dart-define=API_BASE_URL=https://tu-dominio.com
class Env {
  static const String _apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// Base URL para llamadas HTTP, sin barra final.
  /// Prioridad: dart-define > detección de plataforma.
  static String get apiBaseUrl {
    // Si se pasó --dart-define=API_BASE_URL, usar ese valor
    if (_apiBaseUrl.isNotEmpty) {
      return _apiBaseUrl.endsWith('/')
          ? _apiBaseUrl.substring(0, _apiBaseUrl.length - 1)
          : _apiBaseUrl;
    }

    // Si no, seleccionar según plataforma
    if (kIsWeb) return 'http://localhost:8000';

    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:8000';
      if (Platform.isIOS) return 'http://localhost:8000';
      // Desktop (Windows/Mac/Linux)
      return 'http://localhost:8000';
    } catch (e) {
      // Fallback si no se puede determinar plataforma
      return 'http://localhost:8000';
    }
  }

  /// Construye URI absolutas contra `apiBaseUrl`.
  static Uri apiUri(String path, {Map<String, dynamic>? query}) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$apiBaseUrl$normalized').replace(queryParameters: query);
  }
}
