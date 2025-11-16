import 'package:poiquest_frontend_flutter/features/events/data/models/event_model.dart';

class PaginatedEventsModel {
  final List<EventModel> data;
  final String? nextCursor;
  final bool hasNextPage;

  const PaginatedEventsModel({
    required this.data,
    this.nextCursor,
    required this.hasNextPage,
  });

  factory PaginatedEventsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedEventsModel(
      data: (json['data'] as List)
          .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['nextCursor'] as String?,
      hasNextPage: json['hasNextPage'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'nextCursor': nextCursor,
      'hasNextPage': hasNextPage,
    };
  }
}
