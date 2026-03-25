import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_app_bar.dart';
import 'package:poiquest_frontend_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

/// Scaffold principal para el rol `ticket_validator`.
///
/// Layout preparado para la validación de tickets.
/// Solo contiene un destino por ahora; se expandirá cuando se
/// implementen más secciones de validación.
class TicketValidatorMainScaffold extends ConsumerWidget {
  final Widget child;

  const TicketValidatorMainScaffold({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/ticket-validator')) return 0;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        if (isWide) {
          // Pantallas anchas: NavigationRail extendido
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
            body: Row(
              children: [
                NavigationRail(
                  extended: true,
                  selectedIndex: _getCurrentIndex(context),
                  onDestinationSelected: (index) {
                    if (index == 0) {
                      context.go('/ticket-validator');
                    }
                  },
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.qr_code_scanner_rounded),
                      label: Text(l10n.ticketValidator),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: child),
              ],
            ),
          );
        } else {
          // Pantallas móviles: NavigationBar
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
            // bottomNavigationBar: NavigationBar(
            //   selectedIndex: _getCurrentIndex(context),
            //   onDestinationSelected: (index) {
            //     if (index == 0) {
            //       context.go('/ticket-validator');
            //     }
            //   },
            //   destinations: [
            //     NavigationDestination(
            //       icon: const Icon(Icons.qr_code_scanner_rounded),
            //       label: l10n.ticketValidator,
            //     ),
            //   ],
            // ),
            body: child,
          );
        }
      },
    );
  }
}
