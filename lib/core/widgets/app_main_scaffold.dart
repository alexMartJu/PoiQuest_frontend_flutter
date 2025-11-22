import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_app_bar.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_navigation_bar.dart';

class AppMainScaffold extends StatelessWidget {
  final Widget child;

  const AppMainScaffold({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/events')) return 0;
    if (location.startsWith('/tickets')) return 1;
    if (location.startsWith('/scan')) return 2;
    if (location.startsWith('/explore')) return 3;
    if (location.startsWith('/profile')) return 4;

    return 0; // Default a eventos
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
        context.go('/scan');
        break;
      case 3:
        context.go('/explore');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        onSettingsTap: () => context.push('/preferences'),
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTap(context, index),
      ),
      body: child,
    );
  }
}
