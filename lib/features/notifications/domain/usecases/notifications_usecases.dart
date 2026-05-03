import 'package:poiquest_frontend_flutter/features/notifications/domain/entities/app_notification.dart';
import 'package:poiquest_frontend_flutter/features/notifications/domain/repositories/notifications_repository.dart';

class GetNotificationsUseCase {
  const GetNotificationsUseCase(this._repository);
  final NotificationsRepository _repository;

  Future<({List<AppNotification> items, int? nextCursor})> call({
    int? cursor,
    int limit = 20,
  }) =>
      _repository.getNotifications(cursor: cursor, limit: limit);
}

class GetUnreadCountUseCase {
  const GetUnreadCountUseCase(this._repository);
  final NotificationsRepository _repository;

  Future<int> call() => _repository.getUnreadCount();
}

class MarkNotificationReadUseCase {
  const MarkNotificationReadUseCase(this._repository);
  final NotificationsRepository _repository;

  Future<AppNotification> call(int id) => _repository.markAsRead(id);
}

class MarkAllNotificationsReadUseCase {
  const MarkAllNotificationsReadUseCase(this._repository);
  final NotificationsRepository _repository;

  Future<void> call() => _repository.markAllAsRead();
}
