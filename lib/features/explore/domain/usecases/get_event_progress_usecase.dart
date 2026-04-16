import 'package:poiquest_frontend_flutter/features/explore/domain/entities/event_progress.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/repositories/explore_repository.dart';

class GetEventProgress {
  final ExploreRepository repository;

  GetEventProgress(this.repository);

  Future<EventProgress> call({
    required String eventUuid,
    required String visitDate,
  }) =>
      repository.getEventProgress(eventUuid: eventUuid, visitDate: visitDate);
}
