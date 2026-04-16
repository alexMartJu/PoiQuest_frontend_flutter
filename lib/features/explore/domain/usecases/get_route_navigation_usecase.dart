import 'package:poiquest_frontend_flutter/features/explore/domain/entities/route_navigation.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/repositories/explore_repository.dart';

class GetRouteNavigation {
  final ExploreRepository repository;

  GetRouteNavigation(this.repository);

  Future<RouteNavigation> call({
    required String routeUuid,
    required String ticketUuid,
  }) =>
      repository.getRouteNavigation(
        routeUuid: routeUuid,
        ticketUuid: ticketUuid,
      );
}
