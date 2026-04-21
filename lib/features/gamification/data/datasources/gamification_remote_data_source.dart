import 'package:dio/dio.dart';
import 'package:poiquest_frontend_flutter/core/utils/app_service.dart';
import 'package:poiquest_frontend_flutter/core/utils/constants.dart';
import 'package:poiquest_frontend_flutter/features/gamification/data/models/gamification_progress_model.dart';

/// Data source responsable de realizar las llamadas HTTP al backend
/// relacionadas con la feature `gamification`.
///
/// - Traduce la respuesta HTTP cruda en modelos de datos (`*Model`).
/// - Lanza `DioException` para que capas superiores (repositorio/notifier)
///   puedan gestionar mensajes de error apropiados para la UI.
class GamificationRemoteDataSource {
  const GamificationRemoteDataSource();

  /// Obtiene el progreso de gamificación del usuario autenticado.
  Future<GamificationProgressModel> getMyProgress() async {
    try {
      final response = await AppService.dio.get(gamificationProgressEndpoint);

      if (response.statusCode == 200) {
        return GamificationProgressModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Error al obtener progreso de gamificación: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: gamificationProgressEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener progreso de gamificación: $e',
      );
    }
  }
}
