import 'package:equatable/equatable.dart';

enum NotificationType {
  system,
  payment,
  ticket,
  achievement,
  event,
  custom;

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationType.custom,
    );
  }
}

class AppNotification extends Equatable {
  final int id;
  final String title;
  final String message;
  final NotificationType notificationType;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.notificationType,
    required this.isRead,
    required this.createdAt,
  });

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        title: title,
        message: message,
        notificationType: notificationType,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
      );

  @override
  List<Object?> get props => [id, title, message, notificationType, isRead, createdAt];
}
