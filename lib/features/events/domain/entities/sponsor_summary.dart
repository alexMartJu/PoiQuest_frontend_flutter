import 'package:poiquest_frontend_flutter/features/events/domain/entities/image.dart';

class SponsorSummary {
  final String uuid;
  final String name;
  final String? websiteUrl;
  final String? contactEmail;
  final String? description;
  final String status;
  final List<ImageEntity> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SponsorSummary({
    required this.uuid,
    required this.name,
    this.websiteUrl,
    this.contactEmail,
    this.description,
    required this.status,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  /// URL de la imagen principal del patrocinador
  String? get primaryImageUrl {
    if (images.isEmpty) return null;
    final primary = images.where((img) => img.isPrimary).firstOrNull;
    return primary?.imageUrl ?? images.first.imageUrl;
  }
}
