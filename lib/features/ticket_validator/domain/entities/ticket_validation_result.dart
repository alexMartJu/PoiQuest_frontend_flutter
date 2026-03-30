class TicketValidationResult {
  final String uuid;
  final bool valid;
  final String ticketUuid;
  final String? eventName;
  final String? eventCity;
  final String visitDate;
  final DateTime validatedAt;

  const TicketValidationResult({
    required this.uuid,
    required this.valid,
    required this.ticketUuid,
    this.eventName,
    this.eventCity,
    required this.visitDate,
    required this.validatedAt,
  });
}
