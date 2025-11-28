import 'package:poiquest_frontend_flutter/features/admin/domain/repositories/admin_events_repository.dart';

/// Caso de uso para eliminar un evento (Admin)
class DeleteEvent {
  final AdminEventsRepository repository;

  DeleteEvent(this.repository);

  Future<void> call(String uuid) {
    return repository.deleteEvent(uuid);
  }
}
