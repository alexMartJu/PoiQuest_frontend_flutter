import 'package:poiquest_frontend_flutter/features/ticket_validator/domain/entities/validation_history_item.dart';

class ValidationHistoryItemModel {
  final String uuid;
  final bool valid;
  final String? reason;
  final String? ticketUuid;
  final String? eventName;
  final String? eventCity;
  final String? visitDate;
  final DateTime validatedAt;

  const ValidationHistoryItemModel({
    required this.uuid,
    required this.valid,
    this.reason,
    this.ticketUuid,
    this.eventName,
    this.eventCity,
    this.visitDate,
    required this.validatedAt,
  });

  factory ValidationHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return ValidationHistoryItemModel(
      uuid: json['uuid'] as String,
      valid: json['valid'] as bool,
      reason: json['reason'] as String?,
      ticketUuid: json['ticketUuid'] as String?,
      eventName: json['eventName'] as String?,
      eventCity: json['eventCity'] as String?,
      visitDate: json['visitDate'] as String?,
      validatedAt: DateTime.parse(json['validatedAt'] as String).toLocal(),
    );
  }

  ValidationHistoryItem toEntity() {
    return ValidationHistoryItem(
      uuid: uuid,
      valid: valid,
      reason: reason,
      ticketUuid: ticketUuid,
      eventName: eventName,
      eventCity: eventCity,
      visitDate: visitDate,
      validatedAt: validatedAt,
    );
  }
}
