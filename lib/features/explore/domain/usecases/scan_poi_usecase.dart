import 'package:poiquest_frontend_flutter/features/explore/domain/entities/scan_result.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/repositories/explore_repository.dart';

class ScanPoi {
  final ExploreRepository repository;

  ScanPoi(this.repository);

  Future<ScanResult> call({
    required String poiUuid,
    required String ticketUuid,
  }) =>
      repository.scanPoi(poiUuid: poiUuid, ticketUuid: ticketUuid);
}
