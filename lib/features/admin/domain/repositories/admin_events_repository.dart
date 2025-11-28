import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event_category.dart';

/// Repositorio abstracto para operaciones CRUD de eventos (Admin)
abstract class AdminEventsRepository {
  /// Obtiene eventos activos paginados (para listado de admin)
  /// 
  /// [cursor] - Cursor para paginación
  /// [limit] - Número de items por página
  Future<({List<Event> events, String? nextCursor, bool hasNextPage})> getActiveEvents({
    String? cursor,
    int limit = 5,
  });

  /// Crea un nuevo evento
  /// 
  /// [name] - Nombre del evento
  /// [description] - Descripción opcional
  /// [categoryUuid] - UUID de la categoría
  /// [location] - Ubicación opcional
  /// [startDate] - Fecha de inicio (YYYY-MM-DD)
  /// [endDate] - Fecha de fin opcional (YYYY-MM-DD)
  /// [imageUrls] - Lista de URLs de imágenes (mínimo 1, máximo 2)
  Future<Event> createEvent({
    required String name,
    String? description,
    required String categoryUuid,
    String? location,
    required String startDate,
    String? endDate,
    required List<String> imageUrls,
  });

  /// Actualiza un evento existente
  /// 
  /// [uuid] - UUID del evento a actualizar
  /// [name] - Nombre del evento (opcional)
  /// [description] - Descripción (opcional)
  /// [categoryUuid] - UUID de la categoría (opcional)
  /// [location] - Ubicación (opcional)
  /// [startDate] - Fecha de inicio (opcional)
  /// [endDate] - Fecha de fin (opcional)
  /// [imageUrls] - Lista de URLs de imágenes (opcional, máximo 2)
  Future<Event> updateEvent({
    required String uuid,
    String? name,
    String? description,
    String? categoryUuid,
    String? location,
    String? startDate,
    String? endDate,
    List<String>? imageUrls,
  });

  /// Elimina un evento (soft delete)
  /// 
  /// [uuid] - UUID del evento a eliminar
  Future<void> deleteEvent(String uuid);

  /// Obtiene todas las categorías de eventos
  Future<List<EventCategory>> getCategories();
}
