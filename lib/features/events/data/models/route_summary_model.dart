import 'package:poiquest_frontend_flutter/features/events/domain/entities/route_summary.dart';

class RouteSummaryModel {
  final String uuid;
  final String name;

  const RouteSummaryModel({
    required this.uuid,
    required this.name,
  });

  factory RouteSummaryModel.fromJson(Map<String, dynamic> json) {
    return RouteSummaryModel(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
    );
  }

  RouteSummary toEntity() {
    return RouteSummary(
      uuid: uuid,
      name: name,
    );
  }
}
