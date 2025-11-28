import 'package:poiquest_frontend_flutter/features/admin/domain/repositories/admin_events_repository.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';

/// Caso de uso para actualizar un evento (Admin)
class UpdateEvent {
  final AdminEventsRepository repository;

  UpdateEvent(this.repository);

  Future<Event> call({
    required String uuid,
    String? name,
    String? description,
    String? categoryUuid,
    String? location,
    String? startDate,
    String? endDate,
    List<String>? imageUrls,
  }) {
    return repository.updateEvent(
      uuid: uuid,
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
