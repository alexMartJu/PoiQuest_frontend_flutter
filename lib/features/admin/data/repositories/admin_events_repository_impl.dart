import 'package:dio/dio.dart';
import 'package:poiquest_frontend_flutter/features/admin/data/datasources/admin_events_remote_data_source.dart';
import 'package:poiquest_frontend_flutter/features/admin/domain/repositories/admin_events_repository.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event_category.dart';

class AdminEventsRepositoryImpl implements AdminEventsRepository {
  final AdminEventsRemoteDataSource _remoteDataSource;

  AdminEventsRepositoryImpl({
    AdminEventsRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? const AdminEventsRemoteDataSource();

  @override
  Future<({List<Event> events, String? nextCursor, bool hasNextPage})> getActiveEvents({
    String? cursor,
    int limit = 5,
  }) async {
    try {
      final result = await _remoteDataSource.getActiveEvents(
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
      throw Exception('Error inesperado al obtener eventos activos: $e');
    }
  }

  @override
  Future<Event> createEvent({
    required String name,
    String? description,
    required String categoryUuid,
    String? location,
    required String startDate,
    String? endDate,
    required List<String> imageUrls,
  }) async {
    try {
      final model = await _remoteDataSource.createEvent(
        name: name,
        description: description,
        categoryUuid: categoryUuid,
        location: location,
        startDate: startDate,
        endDate: endDate,
        imageUrls: imageUrls,
      );
      return model.toEntity();
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Error inesperado al crear evento: $e');
    }
  }

  @override
  Future<Event> updateEvent({
    required String uuid,
    String? name,
    String? description,
    String? categoryUuid,
    String? location,
    String? startDate,
    String? endDate,
    List<String>? imageUrls,
  }) async {
    try {
      final model = await _remoteDataSource.updateEvent(
        uuid: uuid,
        name: name,
        description: description,
        categoryUuid: categoryUuid,
        location: location,
        startDate: startDate,
        endDate: endDate,
        imageUrls: imageUrls,
      );
      return model.toEntity();
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Error inesperado al actualizar evento: $e');
    }
  }

  @override
  Future<void> deleteEvent(String uuid) async {
    try {
      await _remoteDataSource.deleteEvent(uuid);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Error inesperado al eliminar evento: $e');
    }
  }

  @override
  Future<List<EventCategory>> getCategories() async {
    try {
      final models = await _remoteDataSource.getCategories();
      return models.map((model) => model.toEntity()).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Error inesperado al obtener categorías: $e');
    }
  }

  Exception _handleError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.message ?? 'Error de red';

    switch (statusCode) {
      case 400:
        return Exception('Datos inválidos: $message');
      case 401:
        return Exception('No autorizado. Por favor, inicia sesión nuevamente.');
      case 403:
        return Exception('No tienes permisos para realizar esta acción.');
      case 404:
        return Exception('Evento no encontrado.');
      case 409:
        return Exception('Conflicto: $message');
      case 500:
      case 502:
      case 503:
        return Exception('Error del servidor. Por favor, inténtalo más tarde.');
      default:
        return Exception('Error de red: $message');
    }
  }
}
