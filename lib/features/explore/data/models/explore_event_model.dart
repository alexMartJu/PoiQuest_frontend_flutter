import 'package:poiquest_frontend_flutter/features/explore/domain/entities/explore_event.dart';

class ExploreEventModel {
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

  const ExploreEventModel({
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

  factory ExploreEventModel.fromJson(Map<String, dynamic> json) {
    final event = json['event'] as Map<String, dynamic>;
    final progress = json['progress'] as Map<String, dynamic>;
    return ExploreEventModel(
      ticketUuid: json['ticketUuid'] as String,
      visitDate: json['visitDate'] as String,
      ticketStatus: json['ticketStatus'] as String,
      eventUuid: event['uuid'] as String,
      eventName: event['name'] as String,
      primaryImageUrl: event['primaryImageUrl'] as String?,
      cityName: event['cityName'] as String?,
      startDate: event['startDate'] as String,
      endDate: event['endDate'] as String?,
      totalPois: progress['totalPois'] as int,
      scannedPois: progress['scannedPois'] as int,
    );
  }

  ExploreEvent toEntity() {
    return ExploreEvent(
      ticketUuid: ticketUuid,
      visitDate: visitDate,
      ticketStatus: ticketStatus,
      eventUuid: eventUuid,
      eventName: eventName,
      primaryImageUrl: primaryImageUrl,
      cityName: cityName,
      startDate: startDate,
      endDate: endDate,
      totalPois: totalPois,
      scannedPois: scannedPois,
    );
  }
}
