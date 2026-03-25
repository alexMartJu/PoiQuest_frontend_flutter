import 'package:dio/dio.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/entities/ticket.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/entities/event_availability.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/repositories/tickets_repository.dart';
import 'package:poiquest_frontend_flutter/features/tickets/data/datasources/tickets_remote_data_source.dart';

class TicketsRepositoryImpl implements TicketsRepository {
  final TicketsRemoteDataSource _remoteDataSource;

  TicketsRepositoryImpl({
    TicketsRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? const TicketsRemoteDataSource();

  @override
  Future<({String clientSecret, String paymentIntentId})> createPaymentIntent({
    required String eventUuid,
    required String visitDate,
    required int quantity,
  }) async {
    try {
      return await _remoteDataSource.createPaymentIntent(
        eventUuid: eventUuid,
        visitDate: visitDate,
        quantity: quantity,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> confirmPayment(String paymentIntentId) async {
    try {
      await _remoteDataSource.confirmPayment(paymentIntentId);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<String>> createFreeTickets({
    required String eventUuid,
    required String visitDate,
    required int quantity,
  }) async {
    try {
      return await _remoteDataSource.createFreeTickets(
        eventUuid: eventUuid,
        visitDate: visitDate,
        quantity: quantity,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<Ticket>> getActiveTickets() async {
    try {
      final models = await _remoteDataSource.getActiveTickets();
      return models.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<Ticket>> getUsedTickets() async {
    try {
      final models = await _remoteDataSource.getUsedTickets();
      return models.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<EventAvailability> getEventAvailability(
    String eventUuid,
    String visitDate,
  ) async {
    try {
      final model = await _remoteDataSource.getEventAvailability(
        eventUuid,
        visitDate,
      );
      return model.toEntity();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Error de conexión: Tiempo de espera agotado');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final body = error.response?.data;
        String? message;
        if (body is Map<String, dynamic>) {
          message = body['message'] as String?;
        }
        switch (statusCode) {
          case 400:
            return Exception(message ?? 'Solicitud inválida');
          case 401:
            return Exception('No autorizado');
          case 403:
            return Exception(message ?? 'Acceso prohibido');
          case 404:
            return Exception(message ?? 'Recurso no encontrado');
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
