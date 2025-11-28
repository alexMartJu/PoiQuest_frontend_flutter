import 'package:poiquest_frontend_flutter/features/admin/domain/repositories/admin_events_repository.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';

/// Caso de uso para obtener eventos activos paginados (Admin)
class GetActiveEvents {
  final AdminEventsRepository repository;

  GetActiveEvents(this.repository);

  Future<({List<Event> events, String? nextCursor, bool hasNextPage})> call({
    String? cursor,
    int limit = 5,
  }) {
    return repository.getActiveEvents(
      cursor: cursor,
      limit: limit,
    );
  }
}
