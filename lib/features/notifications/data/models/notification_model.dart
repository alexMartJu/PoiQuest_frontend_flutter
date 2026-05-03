import 'package:poiquest_frontend_flutter/features/notifications/domain/entities/app_notification.dart';

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String notificationType;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.notificationType,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      notificationType: json['notificationType'] as String,
      isRead: json['isRead'] == true || json['isRead'] == 1,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  AppNotification toEntity() {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      notificationType: NotificationType.fromString(notificationType),
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}
