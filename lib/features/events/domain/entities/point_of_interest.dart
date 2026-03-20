import 'package:poiquest_frontend_flutter/features/events/domain/entities/image.dart';

class PointOfInterest {
  final String uuid;
  final String title;
  final String? author;
  final String? description;
  final String? interestingData;
  final String? modelFileName;
  final String? modelUrl;
  final String qrCode;
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
    this.interestingData,
    this.modelFileName,
    this.modelUrl,
    required this.qrCode,
    this.coordX,
    this.coordY,
    this.images,
    required this.createdAt,
    required this.updatedAt,
  });
}
