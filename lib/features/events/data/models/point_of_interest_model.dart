import 'package:poiquest_frontend_flutter/features/events/domain/entities/point_of_interest.dart';
import 'package:poiquest_frontend_flutter/features/events/data/models/image_model.dart';

/// Modelo para Points of Interest (POI) asociados a eventos.
///
/// Sirve para mapear la estructura JSON del backend a la entidad de dominio
/// `PointOfInterest` y para serializar a JSON cuando sea necesario.
class PointOfInterestModel {
  final String uuid;
  final String title;
  final String? author;
  final String? description;
  final Map<String, dynamic>? multimedia;
  final String qrCode;
  final String? nfcTag;
  final double? coordX;
  final double? coordY;
  final List<ImageModel>? images;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PointOfInterestModel({
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

  factory PointOfInterestModel.fromJson(Map<String, dynamic> json) {
    return PointOfInterestModel(
      uuid: json['uuid'] as String,
      title: json['title'] as String,
      author: json['author'] as String?,
      description: json['description'] as String?,
      multimedia: json['multimedia'] as Map<String, dynamic>?,
      qrCode: json['qrCode'] as String,
      nfcTag: json['nfcTag'] as String?,
      coordX: json['coordX'] != null ? (json['coordX'] as num).toDouble() : null,
      coordY: json['coordY'] != null ? (json['coordY'] as num).toDouble() : null,
      images: json['images'] != null
          ? (json['images'] as List).map((e) => ImageModel.fromJson(e as Map<String, dynamic>)).toList()
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'title': title,
      'author': author,
      'description': description,
      'multimedia': multimedia,
      'qrCode': qrCode,
      'nfcTag': nfcTag,
      'coordX': coordX,
      'coordY': coordY,
      'images': images?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  PointOfInterest toEntity() {
    return PointOfInterest(
      uuid: uuid,
      title: title,
      author: author,
      description: description,
      multimedia: multimedia,
      qrCode: qrCode,
      nfcTag: nfcTag,
      coordX: coordX,
      coordY: coordY,
      images: images?.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
