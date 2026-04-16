import 'package:poiquest_frontend_flutter/features/explore/domain/entities/event_progress.dart';

class EventProgressModel {
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
  final List<RouteProgressModel> routes;

  const EventProgressModel({
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

  factory EventProgressModel.fromJson(Map<String, dynamic> json) {
    final event = json['event'] as Map<String, dynamic>;
    final routesList = json['routes'] as List<dynamic>;
    return EventProgressModel(
      ticketUuid: json['ticketUuid'] as String,
      visitDate: json['visitDate'] as String,
      ticketStatus: json['ticketStatus'] as String,
      eventUuid: event['uuid'] as String,
      eventName: event['name'] as String,
      eventDescription: event['description'] as String?,
      primaryImageUrl: event['primaryImageUrl'] as String?,
      cityName: event['cityName'] as String?,
      startDate: event['startDate'] as String,
      endDate: event['endDate'] as String?,
      totalPois: json['totalPois'] as int,
      scannedPois: json['scannedPois'] as int,
      routes: routesList
          .map((r) => RouteProgressModel.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }

  EventProgress toEntity() {
    return EventProgress(
      ticketUuid: ticketUuid,
      visitDate: visitDate,
      ticketStatus: ticketStatus,
      eventUuid: eventUuid,
      eventName: eventName,
      eventDescription: eventDescription,
      primaryImageUrl: primaryImageUrl,
      cityName: cityName,
      startDate: startDate,
      endDate: endDate,
      totalPois: totalPois,
      scannedPois: scannedPois,
      routes: routes.map((r) => r.toEntity()).toList(),
    );
  }
}

class RouteProgressModel {
  final String uuid;
  final String name;
  final String? description;
  final int totalPois;
  final int scannedPois;
  final List<PoiProgressModel> pois;

  const RouteProgressModel({
    required this.uuid,
    required this.name,
    this.description,
    required this.totalPois,
    required this.scannedPois,
    required this.pois,
  });

  factory RouteProgressModel.fromJson(Map<String, dynamic> json) {
    final poisList = json['pois'] as List<dynamic>;
    return RouteProgressModel(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      totalPois: json['totalPois'] as int,
      scannedPois: json['scannedPois'] as int,
      pois: poisList
          .map((p) => PoiProgressModel.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  RouteProgress toEntity() {
    return RouteProgress(
      uuid: uuid,
      name: name,
      description: description,
      totalPois: totalPois,
      scannedPois: scannedPois,
      pois: pois.map((p) => p.toEntity()).toList(),
    );
  }
}

class PoiProgressModel {
  final String uuid;
  final String title;
  final int sortOrder;
  final bool scanned;
  final double? coordX;
  final double? coordY;

  const PoiProgressModel({
    required this.uuid,
    required this.title,
    required this.sortOrder,
    required this.scanned,
    this.coordX,
    this.coordY,
  });

  factory PoiProgressModel.fromJson(Map<String, dynamic> json) {
    return PoiProgressModel(
      uuid: json['uuid'] as String,
      title: json['title'] as String,
      sortOrder: json['sortOrder'] as int,
      scanned: json['scanned'] as bool,
      coordX: (json['coordX'] as num?)?.toDouble(),
      coordY: (json['coordY'] as num?)?.toDouble(),
    );
  }

  PoiProgress toEntity() {
    return PoiProgress(
      uuid: uuid,
      title: title,
      sortOrder: sortOrder,
      scanned: scanned,
      coordX: coordX,
      coordY: coordY,
    );
  }
}
