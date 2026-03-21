import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event_category.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/point_of_interest.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/route_detail.dart';

/// Repositorio abstracto para operaciones con eventos
abstract class EventsRepository {
  /// Obtiene todas las categorías de eventos
  Future<List<EventCategory>> getCategories();

  /// Obtiene eventos paginados por categoría
  /// 
  /// [categoryUuid] - UUID de la categoría (null para todos)
  /// [cursor] - Cursor para paginación
  /// [limit] - Número de items por página
  /// [cityUuid] - Filtro opcional por ciudad
  /// [minPrice] - Filtro opcional por precio mínimo
  /// [maxPrice] - Filtro opcional por precio máximo
  /// [startDate] - Filtro opcional por fecha inicio (ISO 8601)
  /// [endDate] - Filtro opcional por fecha fin (ISO 8601)
  Future<({List<Event> events, String? nextCursor, bool hasNextPage})> getEventsByCategory({
    String? categoryUuid,
    String? cursor,
    int limit = 4,
    String? cityUuid,
    double? minPrice,
    double? maxPrice,
    String? startDate,
    String? endDate,
  });

  /// Obtiene el rango de precios (min, max) de los eventos activos
  Future<({double min, double max})> getPriceRange();

  /// Obtiene todas las ciudades activas del backend
  Future<List<({String uuid, String name})>> getCities();

  /// Obtiene el detalle de un evento activo por UUID
  Future<Event> getEventDetail(String uuid);

  /// Obtiene el detalle de un POI por UUID
  Future<PointOfInterest> getPoiDetail(String uuid);

  /// Obtiene el detalle de una ruta por UUID
  Future<RouteDetail> getRouteDetail(String uuid);
}
