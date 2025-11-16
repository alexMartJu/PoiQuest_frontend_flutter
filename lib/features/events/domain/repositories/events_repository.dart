import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event_category.dart';

/// Repositorio abstracto para operaciones con eventos
abstract class EventsRepository {
  /// Obtiene todas las categorías de eventos
  Future<List<EventCategory>> getCategories();

  /// Obtiene eventos paginados por categoría
  /// 
  /// [categoryUuid] - UUID de la categoría (null para todos)
  /// [cursor] - Cursor para paginación
  /// [limit] - Número de items por página
  Future<({List<Event> events, String? nextCursor, bool hasNextPage})> getEventsByCategory({
    String? categoryUuid,
    String? cursor,
    int limit = 4,
  });
}
