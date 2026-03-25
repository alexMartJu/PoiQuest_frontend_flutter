import 'package:poiquest_frontend_flutter/features/tickets/domain/entities/event_availability.dart';

class EventAvailabilityModel {
  final int? capacity;
  final int sold;
  final int? available;

  const EventAvailabilityModel({
    required this.capacity,
    required this.sold,
    required this.available,
  });

  factory EventAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return EventAvailabilityModel(
      capacity: json['capacity'] as int?,
      sold: json['sold'] as int,
      available: json['available'] as int?,
    );
  }

  EventAvailability toEntity() {
    return EventAvailability(
      capacity: capacity,
      sold: sold,
      available: available,
    );
  }
}
