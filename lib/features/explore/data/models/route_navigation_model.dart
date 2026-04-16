import 'package:poiquest_frontend_flutter/features/explore/domain/entities/route_navigation.dart';

class RouteNavigationModel {
  final String uuid;
  final String name;
  final List<NavigationPoiModel> pois;

  const RouteNavigationModel({
    required this.uuid,
    required this.name,
    required this.pois,
  });

  factory RouteNavigationModel.fromJson(Map<String, dynamic> json) {
    final poisList = json['pois'] as List<dynamic>;
    return RouteNavigationModel(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      pois: poisList
          .map((p) => NavigationPoiModel.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  RouteNavigation toEntity() {
    return RouteNavigation(
      uuid: uuid,
      name: name,
      pois: pois.map((p) => p.toEntity()).toList(),
    );
  }
}

class NavigationPoiModel {
  final String uuid;
  final String title;
  final double? coordX;
  final double? coordY;
  final int sortOrder;
  final bool scanned;
  final String qrCode;

  const NavigationPoiModel({
    required this.uuid,
    required this.title,
    this.coordX,
    this.coordY,
    required this.sortOrder,
    required this.scanned,
    required this.qrCode,
  });

  factory NavigationPoiModel.fromJson(Map<String, dynamic> json) {
    return NavigationPoiModel(
      uuid: json['uuid'] as String,
      title: json['title'] as String,
      coordX: (json['coordX'] as num?)?.toDouble(),
      coordY: (json['coordY'] as num?)?.toDouble(),
      sortOrder: json['sortOrder'] as int,
      scanned: json['scanned'] as bool,
      qrCode: json['qrCode'] as String,
    );
  }

  NavigationPoi toEntity() {
    return NavigationPoi(
      uuid: uuid,
      title: title,
      coordX: coordX,
      coordY: coordY,
      sortOrder: sortOrder,
      scanned: scanned,
      qrCode: qrCode,
    );
  }
}
