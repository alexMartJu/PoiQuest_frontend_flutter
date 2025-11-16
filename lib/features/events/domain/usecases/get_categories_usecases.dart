import 'package:poiquest_frontend_flutter/features/events/domain/repositories/events_repository.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event_category.dart';

/// Caso de uso para obtener las categorías de eventos.
class GetCategories {
  final EventsRepository repository;

  GetCategories(this.repository);

  Future<List<EventCategory>> call() {
    return repository.getCategories();
  }
}
