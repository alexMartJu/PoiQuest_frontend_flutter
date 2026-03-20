import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event_status.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/event_category_model.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/image_model.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/organizer_summary_model.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/point_of_interest_model.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/route_summary_model.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/sponsor_summary_model.dart';

class EventModel {
  final String uuid;
  final String name;
  final String? description;
  final EventCategoryModel? category;
  final EventStatus status;
  final String? cityUuid;
  final String? cityName;
  final OrganizerSummaryModel? organizer;
  final SponsorSummaryModel? sponsor;
  final bool isPremium;
  final double? price;
  final int? capacityPerDay;
  final String startDate;
  final String? endDate;
  final List<PointOfInterestModel>? pointsOfInterest;
  final List<RouteSummaryModel>? routes;
  final List<ImageModel> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.uuid,
    required this.name,
    this.description,
    this.category,
    required this.status,
    this.cityUuid,
    this.cityName,
    this.organizer,
    this.sponsor,
    this.isPremium = false,
    this.price,
    this.capacityPerDay,
    required this.startDate,
    this.endDate,
    this.pointsOfInterest,
    this.routes,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    // Extraer el nombre de la ciudad del objeto city devuelto por el backend
    final cityObj = json['city'] as Map<String, dynamic>?;
    final cityUuid = cityObj?['uuid'] as String?;
    final cityName = cityObj?['name'] as String?;

    // Convertir price a double (el backend lo envía como String decimal)
    final rawPrice = json['price'];
    final price = rawPrice != null ? double.tryParse(rawPrice.toString()) : null;

    return EventModel(
      // Factory para crear el modelo desde el JSON devuelto por el backend.
      // Mantener el `startDate`/`endDate` como ISO strings: la conversión a
      // formato legible se hace en la UI mediante `date_utils` para respetar
      // la localización del usuario.
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] != null
          ? EventCategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      status: EventStatus.fromString(json['status'] as String),
      cityUuid: cityUuid,
      cityName: cityName,
      organizer: json['organizer'] != null
          ? OrganizerSummaryModel.fromJson(json['organizer'] as Map<String, dynamic>)
          : null,
      sponsor: json['sponsor'] != null
          ? SponsorSummaryModel.fromJson(json['sponsor'] as Map<String, dynamic>)
          : null,
      isPremium: json['isPremium'] as bool? ?? false,
      price: price,
      capacityPerDay: json['capacityPerDay'] as int?,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      pointsOfInterest: json['pointsOfInterest'] != null
          ? (json['pointsOfInterest'] as List)
              .map((e) => PointOfInterestModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      routes: json['routes'] != null
          ? (json['routes'] as List)
              .map((e) => RouteSummaryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      images: json['images'] != null
          ? (json['images'] as List)
              .map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'description': description,
      'category': category?.toJson(),
      'status': status.name,
      'cityUuid': cityUuid,
      'cityName': cityName,
      'isPremium': isPremium,
      'price': price,
      'capacityPerDay': capacityPerDay,
      'startDate': startDate,
      'endDate': endDate,
      'pointsOfInterest': pointsOfInterest?.map((e) => e.toJson()).toList(),
      'images': images.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Event toEntity() {
    return Event(
      uuid: uuid,
      name: name,
      description: description,
      category: category?.toEntity(),
      status: status,
      cityUuid: cityUuid,
      cityName: cityName,
      organizer: organizer?.toEntity(),
      sponsor: sponsor?.toEntity(),
      isPremium: isPremium,
      price: price,
      capacityPerDay: capacityPerDay,
      startDate: startDate,
      endDate: endDate,
      pointsOfInterest: pointsOfInterest?.map((e) => e.toEntity()).toList(),
      routes: routes?.map((e) => e.toEntity()).toList(),
      images: images.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
