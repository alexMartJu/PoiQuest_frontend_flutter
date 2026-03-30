import 'package:dio/dio.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/data/datasources/ticket_validator_remote_data_source.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/domain/entities/ticket_validation_result.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/domain/entities/validation_history_item.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/domain/repositories/ticket_validator_repository.dart';

class TicketValidatorRepositoryImpl implements TicketValidatorRepository {
  final TicketValidatorRemoteDataSource _remoteDataSource;

  TicketValidatorRepositoryImpl({
    TicketValidatorRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? const TicketValidatorRemoteDataSource();

  @override
  Future<TicketValidationResult> validateTicket(String qrCode) async {
    try {
      final model = await _remoteDataSource.validateTicket(qrCode);
      return model.toEntity();
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Error inesperado al validar ticket: $e');
    }
  }

  @override
  Future<List<ValidationHistoryItem>> getHistory(String date) async {
    try {
      final models = await _remoteDataSource.getHistory(date);
      return models.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Error inesperado al obtener historial: $e');
    }
  }

  /// Manejo centralizado de errores de Dio
  Exception _handleError(DioException error) {
    // Intentar extraer mensaje del backend para errores con respuesta
    final data = error.response?.data;
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      return Exception(data['message']);
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Error de conexión: Tiempo de espera agotado');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 400:
            return Exception('Solicitud inválida');
          case 401:
            return Exception('No autorizado');
          case 403:
            return Exception('Acceso prohibido');
          case 404:
            return Exception('Recurso no encontrado');
          case 500:
            return Exception('Error del servidor');
          default:
            return Exception('Error del servidor: $statusCode');
        }

      case DioExceptionType.cancel:
        return Exception('Solicitud cancelada');

      case DioExceptionType.connectionError:
        return Exception('Error de conexión: Verifica tu conexión a internet');

      case DioExceptionType.badCertificate:
        return Exception('Error de certificado SSL');

      case DioExceptionType.unknown:
        return Exception('Error inesperado: ${error.message}');
    }
  }
}
