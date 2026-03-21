import 'package:poiquest_frontend_flutter/features/events/domain/entities/point_of_interest.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/repositories/events_repository.dart';

/// Caso de uso para obtener el detalle de un punto de interés por su UUID.
class GetPoiDetail {
  final EventsRepository repository;

  GetPoiDetail(this.repository);

  Future<PointOfInterest> call(String uuid) {
    return repository.getPoiDetail(uuid);
  }
}
