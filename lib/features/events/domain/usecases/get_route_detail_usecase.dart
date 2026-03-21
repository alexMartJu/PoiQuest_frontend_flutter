import 'package:poiquest_frontend_flutter/features/events/domain/entities/route_detail.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/repositories/events_repository.dart';

/// Caso de uso para obtener el detalle de una ruta por su UUID.
class GetRouteDetail {
  final EventsRepository repository;

  GetRouteDetail(this.repository);

  Future<RouteDetail> call(String uuid) {
    return repository.getRouteDetail(uuid);
  }
}
