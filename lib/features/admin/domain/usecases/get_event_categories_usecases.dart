import 'package:poiquest_frontend_flutter/features/admin/domain/repositories/admin_events_repository.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event_category.dart';

/// Caso de uso para obtener las categorías de eventos (Admin)
class GetEventCategories {
  final AdminEventsRepository repository;

  GetEventCategories(this.repository);

  Future<List<EventCategory>> call() {
    return repository.getCategories();
  }
}
