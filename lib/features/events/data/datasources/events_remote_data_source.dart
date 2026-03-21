import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:poiquest_frontend_flutter/core/utils/app_service.dart';
import 'package:poiquest_frontend_flutter/core/utils/constants.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/event_category_model.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/event_model.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/paginated_events_model.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/point_of_interest_model.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/route_detail_model.dart';

/// Data source responsable de realizar las llamadas HTTP al backend
/// relacionadas con la feature `events`.
///
/// Contiene métodos para obtener categorías y eventos (con paginación).
/// - Traduce la respuesta HTTP cruda en modelos de datos (`*Model`).
/// - Lanza `DioException` para que capas superiores (repositorio/notifier)
///   puedan gestionar mensajes de error apropiados para la UI.
class EventsRemoteDataSource {
  const EventsRemoteDataSource();

  /// Obtiene todas las categorías de eventos
  Future<List<EventCategoryModel>> getCategories() async {
    // Realiza GET a /event-categories
    try {
      final response = await AppService.dio.get(eventCategoriesEndpoint);

      if (response.statusCode == 200) {
        // El backend devuelve una lista JSON simple de categorías.
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => EventCategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        // Convertimos respuestas no-200 en DioException para que el repositorio
        // pueda traducirlo a mensajes amigables.
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Error al obtener categorías: ${response.statusCode}',
        );
      }
    } on DioException {
      // Re-lanzar para que el nivel superior lo gestione.
      rethrow;
    } catch (e) {
      // Errores inesperados -> encapsular en DioException con RequestOptions
      throw DioException(
        requestOptions: RequestOptions(path: eventCategoriesEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener categorías: $e',
      );
    }
  }

  /// Obtiene eventos paginados por categoría
  /// 
  /// [categoryUuid] - UUID de la categoría
  /// [cursor] - Cursor para paginación (createdAt en ISO 8601)
  /// [limit] - Número de items por página (por defecto 4)
  /// [cityUuid] - Filtro opcional por ciudad
  /// [minPrice] - Filtro opcional por precio mínimo
  /// [maxPrice] - Filtro opcional por precio máximo
  /// [startDate] - Filtro opcional por fecha inicio (ISO 8601)
  /// [endDate] - Filtro opcional por fecha fin (ISO 8601)
  ///
  /// Expected backend response (paginated):
  /// {
  ///   "data": [ ... ],
  ///   "nextCursor": "2025-...Z" | null,
  ///   "hasNextPage": true|false
  /// }
  Future<PaginatedEventsModel> getEventsByCategory({
    String? categoryUuid,
    String? cursor,
    int limit = 4,
    String? cityUuid,
    double? minPrice,
    double? maxPrice,
    String? startDate,
    String? endDate,
  }) async {
    // If no categoryUuid provided, query the general /events endpoint
    final String basePath = categoryUuid == null || categoryUuid.isEmpty
        ? eventsEndpoint
        : eventsByCategoryEndpoint(categoryUuid);

    final uri = Uri.parse(basePath).replace(
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        'limit': '$limit',
        if (cityUuid != null) 'cityUuid': cityUuid,
        if (minPrice != null) 'minPrice': '$minPrice',
        if (maxPrice != null) 'maxPrice': '$maxPrice',
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
      },
    );

    debugPrint('GET $uri');

    try {
      final response = await AppService.dio.getUri(uri);

      if (kDebugMode) {
        debugPrint('RESPONSE body: ${response.data}');
      }

      if (response.statusCode == 200) {
        final body = response.data;

        if (body is Map<String, dynamic>) {
          // Convertimos la respuesta paginada a nuestro modelo.
          final model = PaginatedEventsModel.fromJson(body);

          if (kDebugMode) {
            debugPrint('PAGINATION: items=${model.data.length} nextCursor=${model.nextCursor} hasNextPage=${model.hasNextPage}');
          }

          return model;
        }

        // Si la respuesta no tiene la forma esperada, lanzar excepción clara.
        throw DioException(
          requestOptions: RequestOptions(path: basePath),
          type: DioExceptionType.unknown,
          message: 'Formato de respuesta inesperado al obtener eventos',
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Error al obtener eventos: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: basePath),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener eventos: $e',
      );
    }
  }

  /// Obtiene el rango de precios (min, max) de los eventos activos
  Future<({double min, double max})> getPriceRange() async {
    try {
      final response = await AppService.dio.get(eventsPriceRangeEndpoint);

      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        final min = (body['min'] as num).toDouble();
        final max = (body['max'] as num).toDouble();
        return (min: min, max: max);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Error al obtener rango de precios: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: eventsPriceRangeEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener rango de precios: $e',
      );
    }
  }

  /// Obtiene todas las ciudades activas del backend (paginadas, se recogen todas)
  Future<List<({String uuid, String name})>> getCities() async {
    try {
      final response = await AppService.dio.get(
        citiesEndpoint,
        queryParameters: {'limit': '100'},
      );

      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>;
        return data.map((json) {
          final map = json as Map<String, dynamic>;
          return (
            uuid: map['uuid'] as String,
            name: map['name'] as String,
          );
        }).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Error al obtener ciudades: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: citiesEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener ciudades: $e',
      );
    }
  }

  /// Obtiene el detalle de un evento activo por UUID
  Future<EventModel> getEventDetail(String uuid) async {
    final path = eventDetailEndpoint(uuid);
    try {
      final response = await AppService.dio.get(path);

      if (response.statusCode == 200) {
        return EventModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Error al obtener detalle del evento: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener detalle del evento: $e',
      );
    }
  }

  /// Obtiene el detalle de un POI por UUID
  Future<PointOfInterestModel> getPoiDetail(String uuid) async {
    final path = poiDetailEndpoint(uuid);
    try {
      final response = await AppService.dio.get(path);

      if (response.statusCode == 200) {
        return PointOfInterestModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Error al obtener detalle del POI: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener detalle del POI: $e',
      );
    }
  }

  /// Obtiene el detalle de una ruta por UUID
  Future<RouteDetailModel> getRouteDetail(String uuid) async {
    final path = routeDetailEndpoint(uuid);
    try {
      final response = await AppService.dio.get(path);

      if (response.statusCode == 200) {
        return RouteDetailModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Error al obtener detalle de la ruta: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener detalle de la ruta: $e',
      );
    }
  }
}
