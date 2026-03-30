class ValidationHistoryItem {
  final String uuid;
  final bool valid;
  final String? reason;
  final String? ticketUuid;
  final String? eventName;
  final String? eventCity;
  final String? visitDate;
  final DateTime validatedAt;

  const ValidationHistoryItem({
    required this.uuid,
    required this.valid,
    this.reason,
    this.ticketUuid,
    this.eventName,
    this.eventCity,
    this.visitDate,
    required this.validatedAt,
  });
}
