import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_app_bar.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_navigation_bar.dart';
import 'package:poiquest_frontend_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:poiquest_frontend_flutter/features/notifications/presentation/providers/notifications_providers.dart';

class AppMainScaffold extends ConsumerStatefulWidget {
  final Widget child;

  const AppMainScaffold({super.key, required this.child});

  @override
  ConsumerState<AppMainScaffold> createState() => _AppMainScaffoldState();
}

class _AppMainScaffoldState extends ConsumerState<AppMainScaffold>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(unreadNotificationsCountProvider);
    }
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/events')) return 0;
    if (location.startsWith('/tickets')) return 1;
    if (location.startsWith('/explore')) return 2;
    if (location.startsWith('/profile')) return 3;

    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/events');
        break;
      case 1:
        context.go('/tickets');
        break;
      case 2:
        context.go('/explore');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).asData?.value;
    final isLoggedIn = user != null;

    // Solo mostrar el badge si el usuario está autenticado
    final unreadCount = isLoggedIn
        ? ref.watch(unreadNotificationsCountProvider).asData?.value ?? 0
        : 0;

    return Scaffold(
      appBar: AppAppBar(
        unreadCount: unreadCount,
        onNotificationsTap: isLoggedIn
            ? () => context.push('/notifications')
            : null,
        onSettingsTap: () => context.push('/preferences'),
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTap(context, index),
      ),
      body: widget.child,
    );
  }
}

