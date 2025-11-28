import 'package:dio/dio.dart';
import 'package:poiquest_frontend_flutter/core/utils/app_service.dart';
import 'package:poiquest_frontend_flutter/core/utils/constants.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/event_model.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/paginated_events_model.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/event_category_model.dart';

/// Data source responsable de realizar las llamadas HTTP al backend
/// relacionadas con las operaciones CRUD de eventos para admin.
class AdminEventsRemoteDataSource {
  const AdminEventsRemoteDataSource();

  /// Obtiene eventos activos paginados
  /// 
  /// [cursor] - Cursor para paginación (createdAt en ISO 8601)
  /// [limit] - Número de items por página (por defecto 5)
  Future<PaginatedEventsModel> getActiveEvents({
    String? cursor,
    int limit = 5,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit.toString(),
      };
      
      if (cursor != null && cursor.isNotEmpty) {
        queryParams['cursor'] = cursor;
      }

      final response = await AppService.dio.get(
        eventsEndpoint,
        queryParameters: queryParams,
      );

      return PaginatedEventsModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? 'Error de red';
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        type: e.type,
        error: message,
        message: message,
      );
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: eventsEndpoint),
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener eventos activos: $e',
      );
    }
  }

  /// Crea un nuevo evento
  Future<EventModel> createEvent({
    required String name,
    String? description,
    required String categoryUuid,
    String? location,
    required String startDate,
    String? endDate,
    required List<String> imageUrls,
  }) async {
    try {
      final body = {
        'name': name,
        'categoryUuid': categoryUuid,
        'startDate': startDate,
        'imageUrls': imageUrls,
        if (description != null) 'description': description,
        if (location != null) 'location': location,
        if (endDate != null) 'endDate': endDate,
      };

      final response = await AppService.dio.post(
        eventsEndpoint,
        data: body,
      );

      return EventModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? 'Error de red';
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        type: e.type,
        error: message,
        message: message,
      );
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: eventsEndpoint),
        type: DioExceptionType.unknown,
        message: 'Error inesperado al crear evento: $e',
      );
    }
  }

  /// Actualiza un evento existente
  Future<EventModel> updateEvent({
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
      final body = <String, dynamic>{};
      
      if (name != null) body['name'] = name;
      if (description != null) body['description'] = description;
      if (categoryUuid != null) body['categoryUuid'] = categoryUuid;
      if (location != null) body['location'] = location;
      if (startDate != null) body['startDate'] = startDate;
      if (endDate != null) body['endDate'] = endDate;
      if (imageUrls != null) body['imageUrls'] = imageUrls;

      final response = await AppService.dio.patch(
        adminEventUpdateEndpoint(uuid),
        data: body,
      );

      return EventModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? 'Error de red';
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        type: e.type,
        error: message,
        message: message,
      );
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: adminEventUpdateEndpoint(uuid)),
        type: DioExceptionType.unknown,
        message: 'Error inesperado al actualizar evento: $e',
      );
    }
  }

  /// Elimina un evento (soft delete)
  Future<void> deleteEvent(String uuid) async {
    try {
      await AppService.dio.delete(
        adminEventDeleteEndpoint(uuid),
      );
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? 'Error de red';
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        type: e.type,
        error: message,
        message: message,
      );
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: adminEventDeleteEndpoint(uuid)),
        type: DioExceptionType.unknown,
        message: 'Error inesperado al eliminar evento: $e',
      );
    }
  }

  /// Obtiene todas las categorías de eventos
  Future<List<EventCategoryModel>> getCategories() async {
    try {
      final response = await AppService.dio.get(eventCategoriesEndpoint);
      final list = response.data as List;
      return list.map((e) => EventCategoryModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? 'Error de red';
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        type: e.type,
        error: message,
        message: message,
      );
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: eventCategoriesEndpoint),
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener categorías: $e',
      );
    }
  }
}
