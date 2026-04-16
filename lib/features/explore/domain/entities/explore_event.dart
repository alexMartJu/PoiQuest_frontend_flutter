class ExploreEvent {
  final String ticketUuid;
  final String visitDate;
  final String ticketStatus;
  final String eventUuid;
  final String eventName;
  final String? primaryImageUrl;
  final String? cityName;
  final String startDate;
  final String? endDate;
  final int totalPois;
  final int scannedPois;

  const ExploreEvent({
    required this.ticketUuid,
    required this.visitDate,
    required this.ticketStatus,
    required this.eventUuid,
    required this.eventName,
    this.primaryImageUrl,
    this.cityName,
    required this.startDate,
    this.endDate,
    required this.totalPois,
    required this.scannedPois,
  });
}
