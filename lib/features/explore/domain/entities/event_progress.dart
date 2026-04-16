class EventProgress {
  final String ticketUuid;
  final String visitDate;
  final String ticketStatus;
  final String eventUuid;
  final String eventName;
  final String? eventDescription;
  final String? primaryImageUrl;
  final String? cityName;
  final String startDate;
  final String? endDate;
  final int totalPois;
  final int scannedPois;
  final List<RouteProgress> routes;

  const EventProgress({
    required this.ticketUuid,
    required this.visitDate,
    required this.ticketStatus,
    required this.eventUuid,
    required this.eventName,
    this.eventDescription,
    this.primaryImageUrl,
    this.cityName,
    required this.startDate,
    this.endDate,
    required this.totalPois,
    required this.scannedPois,
    required this.routes,
  });
}

class RouteProgress {
  final String uuid;
  final String name;
  final String? description;
  final int totalPois;
  final int scannedPois;
  final List<PoiProgress> pois;

  const RouteProgress({
    required this.uuid,
    required this.name,
    this.description,
    required this.totalPois,
    required this.scannedPois,
    required this.pois,
  });
}

class PoiProgress {
  final String uuid;
  final String title;
  final int sortOrder;
  final bool scanned;
  final double? coordX;
  final double? coordY;

  const PoiProgress({
    required this.uuid,
    required this.title,
    required this.sortOrder,
    required this.scanned,
    this.coordX,
    this.coordY,
  });
}
