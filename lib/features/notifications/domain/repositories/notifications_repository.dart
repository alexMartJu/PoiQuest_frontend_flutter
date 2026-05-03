import 'package:poiquest_frontend_flutter/features/notifications/domain/entities/app_notification.dart';

abstract class NotificationsRepository {
  Future<({List<AppNotification> items, int? nextCursor})> getNotifications({
    int? cursor,
    int limit = 20,
  });

  Future<int> getUnreadCount();

  Future<AppNotification> markAsRead(int id);

  Future<void> markAllAsRead();
}
