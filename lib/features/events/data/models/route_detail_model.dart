import 'package:poiquest_frontend_flutter/features/events/data/models/point_of_interest_model.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/route_detail.dart';

class RoutePoiEntryModel {
  final int sortOrder;
  final PointOfInterestModel poi;

  const RoutePoiEntryModel({
    required this.sortOrder,
    required this.poi,
  });

  factory RoutePoiEntryModel.fromJson(Map<String, dynamic> json) {
    return RoutePoiEntryModel(
      sortOrder: json['sortOrder'] as int,
      poi: PointOfInterestModel.fromJson(json['poi'] as Map<String, dynamic>),
    );
  }

  RoutePoiEntry toEntity() {
    return RoutePoiEntry(
      sortOrder: sortOrder,
      poi: poi.toEntity(),
    );
  }
}

class RouteDetailModel {
  final String uuid;
  final String name;
  final String? description;
  final List<RoutePoiEntryModel> pois;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RouteDetailModel({
    required this.uuid,
    required this.name,
    this.description,
    required this.pois,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RouteDetailModel.fromJson(Map<String, dynamic> json) {
    return RouteDetailModel(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      pois: json['pois'] != null
          ? (json['pois'] as List)
              .map((e) => RoutePoiEntryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  RouteDetail toEntity() {
    return RouteDetail(
      uuid: uuid,
      name: name,
      description: description,
      pois: pois.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
