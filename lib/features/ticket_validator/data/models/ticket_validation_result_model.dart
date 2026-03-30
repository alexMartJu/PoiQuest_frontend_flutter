import 'package:poiquest_frontend_flutter/features/ticket_validator/domain/entities/ticket_validation_result.dart';

class TicketValidationResultModel {
  final String uuid;
  final bool valid;
  final String ticketUuid;
  final String? eventName;
  final String? eventCity;
  final String visitDate;
  final DateTime validatedAt;

  const TicketValidationResultModel({
    required this.uuid,
    required this.valid,
    required this.ticketUuid,
    this.eventName,
    this.eventCity,
    required this.visitDate,
    required this.validatedAt,
  });

  factory TicketValidationResultModel.fromJson(Map<String, dynamic> json) {
    return TicketValidationResultModel(
      uuid: json['uuid'] as String,
      valid: json['valid'] as bool,
      ticketUuid: json['ticketUuid'] as String,
      eventName: json['eventName'] as String?,
      eventCity: json['eventCity'] as String?,
      visitDate: json['visitDate'] as String,
      validatedAt: DateTime.parse(json['validatedAt'] as String).toLocal(),
    );
  }

  TicketValidationResult toEntity() {
    return TicketValidationResult(
      uuid: uuid,
      valid: valid,
      ticketUuid: ticketUuid,
      eventName: eventName,
      eventCity: eventCity,
      visitDate: visitDate,
      validatedAt: validatedAt,
    );
  }
}
