import 'package:poiquest_frontend_flutter/features/events/domain/repositories/events_repository.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';

/// Caso de uso que encapsula la obtención paginada de eventos por categoría.
///
/// Devuelve un record con la lista de eventos, el cursor siguiente y el flag
/// `hasNextPage`. Mantener esta pequeña capa facilita añadir validaciones,
/// caching o composición de fuentes en el futuro sin tocar el Notifier.
class GetEventsByCategory {
  final EventsRepository repository;

  GetEventsByCategory(this.repository);

  Future<({List<Event> events, String? nextCursor, bool hasNextPage})> call({
    String? categoryUuid,
    String? cursor,
    int limit = 4,
  }) {
    return repository.getEventsByCategory(
      categoryUuid: categoryUuid,
      cursor: cursor,
      limit: limit,
    );
  }
}
