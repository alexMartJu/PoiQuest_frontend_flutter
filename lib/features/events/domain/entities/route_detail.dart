import 'package:poiquest_frontend_flutter/features/events/domain/entities/point_of_interest.dart';

class RoutePoiEntry {
  final int sortOrder;
  final PointOfInterest poi;

  const RoutePoiEntry({
    required this.sortOrder,
    required this.poi,
  });
}

class RouteDetail {
  final String uuid;
  final String name;
  final String? description;
  final List<RoutePoiEntry> pois;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RouteDetail({
    required this.uuid,
    required this.name,
    this.description,
    required this.pois,
    required this.createdAt,
    required this.updatedAt,
  });
}
