import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event_status.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/event_category_model.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/image_model.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/point_of_interest_model.dart';

class EventModel {
  final String uuid;
  final String name;
  final String? description;
  final EventCategoryModel? category;
  final EventStatus status;
  final String? location;
  final String startDate;
  final String? endDate;
  final List<PointOfInterestModel>? pointsOfInterest;
  final List<ImageModel> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.uuid,
    required this.name,
    this.description,
    this.category,
    required this.status,
    this.location,
    required this.startDate,
    this.endDate,
    this.pointsOfInterest,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
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
      location: json['location'] as String?,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      pointsOfInterest: json['pointsOfInterest'] != null
          ? (json['pointsOfInterest'] as List)
              .map((e) => PointOfInterestModel.fromJson(e as Map<String, dynamic>))
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
      'location': location,
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
      location: location,
      startDate: startDate,
      endDate: endDate,
      pointsOfInterest: pointsOfInterest?.map((e) => e.toEntity()).toList(),
      images: images.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
