import 'package:poiquest_frontend_flutter/features/events/domain/entities/image.dart';

class PointOfInterest {
  final String uuid;
  final String title;
  final String? author;
  final String? description;
  final Map<String, dynamic>? multimedia;
  final String qrCode;
  final String? nfcTag;
  final double? coordX;
  final double? coordY;
  final List<ImageEntity>? images;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PointOfInterest({
    required this.uuid,
    required this.title,
    this.author,
    this.description,
    this.multimedia,
    required this.qrCode,
    this.nfcTag,
    this.coordX,
    this.coordY,
    this.images,
    required this.createdAt,
    required this.updatedAt,
  });
}
