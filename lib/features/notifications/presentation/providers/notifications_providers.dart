import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:poiquest_frontend_flutter/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:poiquest_frontend_flutter/features/notifications/domain/entities/app_notification.dart';
import 'package:poiquest_frontend_flutter/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:poiquest_frontend_flutter/features/notifications/domain/usecases/notifications_usecases.dart';

// ---------- Infrastructure providers ----------

final notificationsRemoteDataSourceProvider =
    Provider<NotificationsRemoteDataSource>((ref) {
  return const NotificationsRemoteDataSource();
});

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepositoryImpl(
    remoteDataSource: ref.watch(notificationsRemoteDataSourceProvider),
  );
});

// ---------- Use case providers ----------

final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((ref) {
  return GetNotificationsUseCase(ref.watch(notificationsRepositoryProvider));
});

final getUnreadCountUseCaseProvider = Provider<GetUnreadCountUseCase>((ref) {
  return GetUnreadCountUseCase(ref.watch(notificationsRepositoryProvider));
});

final markNotificationReadUseCaseProvider = Provider<MarkNotificationReadUseCase>((ref) {
  return MarkNotificationReadUseCase(ref.watch(notificationsRepositoryProvider));
});

final markAllNotificationsReadUseCaseProvider =
    Provider<MarkAllNotificationsReadUseCase>((ref) {
  return MarkAllNotificationsReadUseCase(ref.watch(notificationsRepositoryProvider));
});

// ---------- Unread count provider ----------

final unreadNotificationsCountProvider = FutureProvider<int>((ref) async {
  final usecase = ref.watch(getUnreadCountUseCaseProvider);
  return usecase();
});

// ---------- Notifications page state ----------

class NotificationsState extends Equatable {
  final List<AppNotification> items;
  final int? nextCursor;
  final bool isLoadingMore;

  const NotificationsState({
    this.items = const [],
    this.nextCursor,
    this.isLoadingMore = false,
  });

  NotificationsState copyWith({
    List<AppNotification>? items,
    int? nextCursor,
    bool clearNextCursor = false,
    bool? isLoadingMore,
  }) =>
      NotificationsState(
        items: items ?? this.items,
        nextCursor: clearNextCursor ? null : nextCursor ?? this.nextCursor,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );

  @override
  List<Object?> get props => [items, nextCursor, isLoadingMore];
}

class NotificationsNotifier extends AsyncNotifier<NotificationsState> {
  late final GetNotificationsUseCase _getNotifications;
  late final MarkNotificationReadUseCase _markRead;
  late final MarkAllNotificationsReadUseCase _markAllRead;

  @override
  Future<NotificationsState> build() async {
    _getNotifications = ref.read(getNotificationsUseCaseProvider);
    _markRead = ref.read(markNotificationReadUseCaseProvider);
    _markAllRead = ref.read(markAllNotificationsReadUseCaseProvider);
    return _fetchPage(cursor: null);
  }

  Future<NotificationsState> _fetchPage({int? cursor}) async {
    final result = await _getNotifications(cursor: cursor);
    return NotificationsState(
      items: result.items,
      nextCursor: result.nextCursor,
    );
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null || current.nextCursor == null || current.isLoadingMore) return;

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));

    final result = await _getNotifications(cursor: current.nextCursor);
    state = AsyncValue.data(current.copyWith(
      items: [...current.items, ...result.items],
      nextCursor: result.nextCursor,
      isLoadingMore: false,
    ));
  }

  Future<void> markAsRead(int id) async {
    final updated = await _markRead(id);
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(
      items: current.items.map((n) => n.id == id ? updated : n).toList(),
    ));
    // Invalidar el contador de no leídas
    ref.invalidate(unreadNotificationsCountProvider);
  }

  Future<void> markAllAsRead() async {
    await _markAllRead();
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(
      items: current.items.map((n) => n.copyWith(isRead: true)).toList(),
    ));
    ref.invalidate(unreadNotificationsCountProvider);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPage(cursor: null));
    ref.invalidate(unreadNotificationsCountProvider);
  }
}

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, NotificationsState>(
  NotificationsNotifier.new,
);
