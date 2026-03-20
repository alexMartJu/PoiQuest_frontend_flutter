import 'package:poiquest_frontend_flutter/features/events/data/models/image_model.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/organizer_summary.dart';

class OrganizerSummaryModel {
  final String uuid;
  final String name;
  final String type;
  final String contactEmail;
  final String? contactPhone;
  final String? description;
  final String status;
  final List<ImageModel> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrganizerSummaryModel({
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

  factory OrganizerSummaryModel.fromJson(Map<String, dynamic> json) {
    return OrganizerSummaryModel(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      contactEmail: json['contactEmail'] as String,
      contactPhone: json['contactPhone'] as String?,
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

  OrganizerSummary toEntity() {
    return OrganizerSummary(
      uuid: uuid,
      name: name,
      type: type,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      description: description,
      status: status,
      images: images.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
