import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_app_bar.dart';
import 'package:poiquest_frontend_flutter/core/widgets/ticket_validator_navigation_bar.dart';
import 'package:poiquest_frontend_flutter/features/auth/presentation/providers/auth_provider.dart';

/// Scaffold principal para el rol `ticket_validator`.
///
/// Layout con AppBar + NavigationBar inferior con dos destinos:
/// - Escáner de tickets (/ticket-validator)
/// - Historial de validaciones (/ticket-validator/history)
class TicketValidatorMainScaffold extends ConsumerWidget {
  final Widget child;

  const TicketValidatorMainScaffold({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/ticket-validator/history')) return 1;
    if (location.startsWith('/ticket-validator')) return 0;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/ticket-validator');
        break;
      case 1:
        context.go('/ticket-validator/history');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppAppBar(
        onSettingsTap: () => context.push('/preferences'),
        onLogoutTap: () async {
          await ref.read(authProvider.notifier).signOut();
          if (context.mounted) {
            context.go('/events');
          }
        },
      ),
      bottomNavigationBar: TicketValidatorNavigationBar(
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTap(context, index),
      ),
      body: child,
    );
  }
}
