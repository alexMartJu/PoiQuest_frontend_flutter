import 'package:poiquest_frontend_flutter/features/explore/domain/entities/explore_event.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/repositories/explore_repository.dart';

class GetExploreEvents {
  final ExploreRepository repository;

  GetExploreEvents(this.repository);

  Future<({List<ExploreEvent> data, String? nextCursor, bool hasNextPage})>
      call({
    required String status,
    String? cursor,
    int limit = 4,
  }) =>
          repository.getMyEvents(status: status, cursor: cursor, limit: limit);
}
