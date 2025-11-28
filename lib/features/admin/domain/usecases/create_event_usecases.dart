import 'package:poiquest_frontend_flutter/features/admin/domain/repositories/admin_events_repository.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';

/// Caso de uso para crear un evento (Admin)
class CreateEvent {
  final AdminEventsRepository repository;

  CreateEvent(this.repository);

  Future<Event> call({
    required String name,
    String? description,
    required String categoryUuid,
    String? location,
    required String startDate,
    String? endDate,
    required List<String> imageUrls,
  }) {
    return repository.createEvent(
      name: name,
      description: description,
      categoryUuid: categoryUuid,
      location: location,
      startDate: startDate,
      endDate: endDate,
      imageUrls: imageUrls,
    );
  }
}
