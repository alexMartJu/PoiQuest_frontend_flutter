import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_button.dart';
import 'package:poiquest_frontend_flutter/features/notifications/domain/entities/app_notification.dart';
import 'package:poiquest_frontend_flutter/features/notifications/presentation/providers/notifications_providers.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(notificationsProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.notificationsPageTitle),
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, size: 56, color: c.error),
                const SizedBox(height: 16),
                Text(
                  t.notificationsErrorLoading,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: c.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                AppButton(
                  label: t.retryButton,
                  onPressed: () =>
                      ref.read(notificationsProvider.notifier).refresh(),
                ),
              ],
            ),
          ),
        ),
        data: (state) {
          if (state.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 72,
                      color: c.onSurface.withAlpha(60),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      t.notificationsEmpty,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: c.onSurface.withAlpha(160),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      t.notificationsEmptySubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: c.onSurface.withAlpha(100),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final hasUnread = state.items.any((n) => !n.isRead);

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(notificationsProvider.notifier).refresh(),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (hasUnread)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: AppButton(
                          label: t.notificationsMarkAllRead,
                          onPressed: () => ref
                              .read(notificationsProvider.notifier)
                              .markAllAsRead(),
                        ),
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16, hasUnread ? 4 : 12, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == state.items.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final notification = state.items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _NotificationCard(
                            notification: notification,
                            onTap: () {
                              if (!notification.isRead) {
                                ref
                                    .read(notificationsProvider.notifier)
                                    .markAsRead(notification.id);
                              }
                            },
                          ),
                        );
                      },
                      childCount: state.items.length +
                          (state.isLoadingMore ? 1 : 0),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  final AppNotification notification;
  final VoidCallback onTap;

  IconData _iconFor(NotificationType type) {
    return switch (type) {
      NotificationType.event => Icons.event_rounded,
      NotificationType.ticket => Icons.confirmation_number_rounded,
      NotificationType.payment => Icons.payment_rounded,
      NotificationType.achievement => Icons.emoji_events_rounded,
      NotificationType.system => Icons.info_rounded,
      NotificationType.custom => Icons.notifications_rounded,
    };
  }

  Color _colorFor(NotificationType type, ColorScheme c) {
    return switch (type) {
      NotificationType.event => c.tertiary,
      NotificationType.ticket => c.primary,
      NotificationType.payment => const Color(0xFF4CAF50),
      NotificationType.achievement => c.warning,
      NotificationType.system => c.secondary,
      NotificationType.custom => c.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final t = AppLocalizations.of(context)!;
    final typeColor = _colorFor(notification.notificationType, c);

    return Card(
      elevation: notification.isRead ? 0 : 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: notification.isRead
              ? c.outlineVariant.withAlpha(80)
              : c.primary.withAlpha(60),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!notification.isRead)
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: typeColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: typeColor
                              .withAlpha(notification.isRead ? 30 : 50),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _iconFor(notification.notificationType),
                          size: 20,
                          color: typeColor
                              .withAlpha(notification.isRead ? 150 : 230),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    notification.title,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: notification.isRead
                                          ? FontWeight.w400
                                          : FontWeight.w600,
                                      color: c.onSurface,
                                    ),
                                  ),
                                ),
                                if (!notification.isRead) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      color: typeColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification.message,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: c.onSurfaceVariant,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _formatDate(notification.createdAt, t),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: c.onSurface.withAlpha(100),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date, AppLocalizations t) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return t.notificationTimeJustNow;
    if (diff.inHours < 1) return t.notificationTimeMinutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return t.notificationTimeHoursAgo(diff.inHours);
    if (diff.inDays == 1) return t.notificationTimeYesterday;
    if (diff.inDays < 7) return t.notificationTimeDaysAgo(diff.inDays);
    return '${date.day}/${date.month}/${date.year}';
  }
}
