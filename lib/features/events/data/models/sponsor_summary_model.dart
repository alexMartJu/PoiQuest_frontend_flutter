import 'package:poiquest_frontend_flutter/features/events/data/models/image_model.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/sponsor_summary.dart';

class SponsorSummaryModel {
  final String uuid;
  final String name;
  final String? websiteUrl;
  final String? contactEmail;
  final String? description;
  final String status;
  final List<ImageModel> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SponsorSummaryModel({
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

  factory SponsorSummaryModel.fromJson(Map<String, dynamic> json) {
    return SponsorSummaryModel(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      websiteUrl: json['websiteUrl'] as String?,
      contactEmail: json['contactEmail'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String,
      images: json['images'] != null
          ? (json['images'] as List)
              .map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  SponsorSummary toEntity() {
    return SponsorSummary(
      uuid: uuid,
      name: name,
      websiteUrl: websiteUrl,
      contactEmail: contactEmail,
      description: description,
      status: status,
      images: images.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
