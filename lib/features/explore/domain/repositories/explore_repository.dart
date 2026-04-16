import 'package:poiquest_frontend_flutter/features/explore/domain/entities/explore_event.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/event_progress.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/scan_result.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/route_navigation.dart';

abstract class ExploreRepository {
  Future<({List<ExploreEvent> data, String? nextCursor, bool hasNextPage})>
      getMyEvents({
    required String status,
    String? cursor,
    int limit = 4,
  });

  Future<EventProgress> getEventProgress({
    required String eventUuid,
    required String visitDate,
  });

  Future<ScanResult> scanPoi({
    required String poiUuid,
    required String ticketUuid,
  });

  Future<RouteNavigation> getRouteNavigation({
    required String routeUuid,
    required String ticketUuid,
  });
}
