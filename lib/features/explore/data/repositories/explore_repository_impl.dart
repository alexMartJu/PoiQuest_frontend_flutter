import 'package:dio/dio.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/explore_event.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/event_progress.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/scan_result.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/route_navigation.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/repositories/explore_repository.dart';
import 'package:poiquest_frontend_flutter/features/explore/data/datasources/explore_remote_data_source.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  final ExploreRemoteDataSource _remoteDataSource;

  ExploreRepositoryImpl({
    ExploreRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? const ExploreRemoteDataSource();

  @override
  Future<({List<ExploreEvent> data, String? nextCursor, bool hasNextPage})>
      getMyEvents({
    required String status,
    String? cursor,
    int limit = 4,
  }) async {
    try {
      final result = await _remoteDataSource.getMyEvents(
        status: status,
        cursor: cursor,
        limit: limit,
      );
      return (
        data: result.data.map((m) => m.toEntity()).toList(),
        nextCursor: result.nextCursor,
        hasNextPage: result.hasNextPage,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<EventProgress> getEventProgress({
    required String eventUuid,
    required String visitDate,
  }) async {
    try {
      final model = await _remoteDataSource.getEventProgress(
        eventUuid: eventUuid,
        visitDate: visitDate,
      );
      return model.toEntity();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ScanResult> scanPoi({
    required String poiUuid,
    required String ticketUuid,
  }) async {
    try {
      final model = await _remoteDataSource.scanPoi(
        poiUuid: poiUuid,
        ticketUuid: ticketUuid,
      );
      return model.toEntity();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<RouteNavigation> getRouteNavigation({
    required String routeUuid,
    required String ticketUuid,
  }) async {
    try {
      final model = await _remoteDataSource.getRouteNavigation(
        routeUuid: routeUuid,
        ticketUuid: ticketUuid,
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
