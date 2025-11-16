import 'package:dio/dio.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event_category.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/repositories/events_repository.dart';
import 'package:poiquest_frontend_flutter/features/events/data/datasources/events_remote_data_source.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource _remoteDataSource;

  EventsRepositoryImpl({
    EventsRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? const EventsRemoteDataSource();

  @override
  Future<List<EventCategory>> getCategories() async {
    // Obtiene modelos desde el data source y los convierte a entidades del
    // dominio que consumen las capas superiores. El repositorio hace de
    // adaptador entre la capa de datos (models) y la capa de dominio (entities).
    try {
      final models = await _remoteDataSource.getCategories();
      return models.map((model) => model.toEntity()).toList();
    } on DioException catch (e) {
      // Convertimos errores de red en excepciones legibles para la UI.
      throw _handleError(e);
    } catch (e) {
      throw Exception('Error inesperado al obtener categorías: $e');
    }
  }

  @override
  Future<({List<Event> events, String? nextCursor, bool hasNextPage})> getEventsByCategory({
    String? categoryUuid,
    String? cursor,
    int limit = 4,
  }) async {
    // Lógica de obtención paginada: delega al data source y transforma el
    // resultado a una estructura simple que contiene la lista de eventos,
    // el cursor para la siguiente página y el flag hasNextPage.
    try {
      final result = await _remoteDataSource.getEventsByCategory(
        categoryUuid: categoryUuid,
        cursor: cursor,
        limit: limit,
      );

      return (
        events: result.data.map((model) => model.toEntity()).toList(),
        nextCursor: result.nextCursor,
        hasNextPage: result.hasNextPage,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Error inesperado al obtener eventos: $e');
    }
  }

  /// Manejo centralizado de errores de Dio
  Exception _handleError(DioException error) {
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
