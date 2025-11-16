import 'package:poiquest_frontend_flutter/features/events/domain/entities/image.dart';

/// Modelo que representa una imagen asociada a un recurso de events (POI/event).
///
/// Incluye lógica defensiva en `fromJson` para aceptar diferentes shapes
/// de la API (p.ej. `isPrimary` como 0/1, 'true'/'false', o booleano).
class ImageModel {
  final int id;
  final String imageUrl;
  final int sortOrder;
  final bool isPrimary;
  final DateTime createdAt;

  const ImageModel({
    required this.id,
    required this.imageUrl,
    required this.sortOrder,
    required this.isPrimary,
    required this.createdAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    // Algunas APIs devuelven 0/1 en lugar de bool para campos como isPrimary.
    // Manejar tipos dinámicos para evitar errores de casteo.
    final dynamic rawIsPrimary = json['isPrimary'] ?? json['is_primary'];
    bool parseIsPrimary(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) {
        final lower = v.toLowerCase();
        return lower == '1' || lower == 'true' || lower == 'yes';
      }
      return false;
    }

    return ImageModel(
      id: json['id'] as int,
      imageUrl: (json['imageUrl'] ?? json['image_url']) as String,
      sortOrder: json['sortOrder'] ?? json['sort_order'] as int,
      isPrimary: parseIsPrimary(rawIsPrimary),
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'sortOrder': sortOrder,
      'isPrimary': isPrimary,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ImageEntity toEntity() {
    return ImageEntity(
      id: id,
      imageUrl: imageUrl,
      sortOrder: sortOrder,
      isPrimary: isPrimary,
      createdAt: createdAt,
    );
  }
}
