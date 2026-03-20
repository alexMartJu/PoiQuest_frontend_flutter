import 'package:poiquest_frontend_flutter/features/events/domain/entities/event_category.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event_status.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/image.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/organizer_summary.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/point_of_interest.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/route_summary.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/sponsor_summary.dart';

class Event {
  final String uuid;
  final String name;
  final String? description;
  final EventCategory? category;
  final EventStatus status;
  final String? cityUuid;
  final String? cityName;
  final OrganizerSummary? organizer;
  final SponsorSummary? sponsor;
  final bool isPremium;
  final double? price;
  final int? capacityPerDay;
  final String startDate;
  final String? endDate;
  final List<PointOfInterest>? pointsOfInterest;
  final List<RouteSummary>? routes;
  final List<ImageEntity> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Event({
    required this.uuid,
    required this.name,
    this.description,
    this.category,
    required this.status,
    this.cityUuid,
    this.cityName,
    this.organizer,
    this.sponsor,
    this.isPremium = false,
    this.price,
    this.capacityPerDay,
    required this.startDate,
    this.endDate,
    this.pointsOfInterest,
    this.routes,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Retorna la imagen principal o la primera disponible
  String? get primaryImageUrl {
    if (images.isEmpty) return null;
    
    final primary = images.where((img) => img.isPrimary).firstOrNull;
    if (primary != null) return primary.imageUrl;
    
    return images.first.imageUrl;
  }
}
