import 'package:poiquest_frontend_flutter/features/tickets/domain/entities/ticket_status.dart';

class Ticket {
  final String uuid;
  final String eventName;
  final String eventUuid;
  final String? eventCity;
  final String visitDate;
  final TicketStatus status;
  final String? qrCode;
  final bool isFreeEvent;
  final DateTime purchaseDate;

  const Ticket({
    required this.uuid,
    required this.eventName,
    required this.eventUuid,
    this.eventCity,
    required this.visitDate,
    required this.status,
    this.qrCode,
    required this.isFreeEvent,
    required this.purchaseDate,
  });
}
