import 'package:poiquest_frontend_flutter/features/tickets/domain/entities/ticket.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/entities/ticket_status.dart';

class TicketModel {
  final String uuid;
  final String eventName;
  final String eventUuid;
  final String? eventCity;
  final String visitDate;
  final TicketStatus status;
  final String? qrCode;
  final bool isFreeEvent;
  final DateTime purchaseDate;

  const TicketModel({
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

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      uuid: json['uuid'] as String,
      eventName: json['eventName'] as String,
      eventUuid: json['eventUuid'] as String,
      eventCity: json['eventCity'] as String?,
      visitDate: json['visitDate'] as String,
      status: TicketStatus.fromString(json['status'] as String),
      qrCode: json['qrCode'] as String?,
      isFreeEvent: json['isFreeEvent'] as bool? ?? false,
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
    );
  }

  Ticket toEntity() {
    return Ticket(
      uuid: uuid,
      eventName: eventName,
      eventUuid: eventUuid,
      eventCity: eventCity,
      visitDate: visitDate,
      status: status,
      qrCode: qrCode,
      isFreeEvent: isFreeEvent,
      purchaseDate: purchaseDate,
    );
  }
}
