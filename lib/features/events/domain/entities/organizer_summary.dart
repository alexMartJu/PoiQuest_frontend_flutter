import 'package:poiquest_frontend_flutter/features/events/domain/entities/image.dart';

class OrganizerSummary {
  final String uuid;
  final String name;
  final String type;
  final String contactEmail;
  final String? contactPhone;
  final String? description;
  final String status;
  final List<ImageEntity> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrganizerSummary({
    required this.uuid,
    required this.name,
    required this.type,
    required this.contactEmail,
    this.contactPhone,
    this.description,
    required this.status,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  /// URL de la imagen principal del organizador
  String? get primaryImageUrl {
    if (images.isEmpty) return null;
    final primary = images.where((img) => img.isPrimary).firstOrNull;
    return primary?.imageUrl ?? images.first.imageUrl;
  }
}
