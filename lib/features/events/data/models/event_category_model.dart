import 'package:poiquest_frontend_flutter/features/events/domain/entities/event_category.dart';

/// Modelo de datos para una categoría de evento tal como la devuelve el API.
///
/// Responsable de:
/// - Mapear JSON -> `EventCategoryModel`
/// - Serializar (`toJson`) cuando sea necesario
/// - Convertir a la entidad de dominio `EventCategory` mediante `toEntity()`
class EventCategoryModel {
  final String uuid;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventCategoryModel({
    required this.uuid,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventCategoryModel.fromJson(Map<String, dynamic> json) {
    return EventCategoryModel(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  EventCategory toEntity() {
    return EventCategory(
      uuid: uuid,
      name: name,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
