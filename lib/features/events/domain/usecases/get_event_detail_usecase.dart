import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/repositories/events_repository.dart';

/// Caso de uso para obtener el detalle de un evento por su UUID.
class GetEventDetail {
  final EventsRepository repository;

  GetEventDetail(this.repository);

  Future<Event> call(String uuid) {
    return repository.getEventDetail(uuid);
  }
}
