import 'package:poiquest_frontend_flutter/features/tickets/domain/entities/event_availability.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/repositories/tickets_repository.dart';

class GetEventAvailability {
  final TicketsRepository repository;

  GetEventAvailability(this.repository);

  Future<EventAvailability> call(String eventUuid, String visitDate) {
    return repository.getEventAvailability(eventUuid, visitDate);
  }
}
