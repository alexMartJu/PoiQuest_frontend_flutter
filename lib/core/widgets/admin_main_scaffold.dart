import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_app_bar.dart';
import 'package:poiquest_frontend_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

class AdminMainScaffold extends ConsumerWidget {
  final Widget child;

  const AdminMainScaffold({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/admin/events')) return 0;
    // Aquí se añaden más rutas aquí cuando haya más secciones
    return 0;
  }

  void _onDestinationSelected(BuildContext context, WidgetRef ref, int index) {
    switch (index) {
      case 0:
        context.go('/admin/events');
        break;
      case 1:
        // Botón "Más" - Mostrar modal con opciones secundarias
        _showMoreOptions(context, ref);
        break;
    }
  }

  void _showMoreOptions(BuildContext context, WidgetRef ref) {
    // Actualmente no mostramos opciones; este modal queda reservado
    // para añadir opciones secundarias en el futuro.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (context) {
        // Usar DraggableScrollableSheet para permitir arrastrar el sheet
        // hacia arriba y expandirlo aunque el contenido esté vacío.
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.08,
          minChildSize: 0.06,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Contenido reservado intencionalmente vacío para el futuro.
                  // Dejar un espacio mínimo para que el sheet pueda
                  // expandirse visualmente cuando el usuario lo arrastre.
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      context.go('/admin/events');
                    }
                  },
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.event),
                      label: Text(AppLocalizations.of(context)!.navEvents),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: child),
              ],
            ),
          );
        } else {
          // Pantallas móviles: NavigationBar con botón "Más"
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
            bottomNavigationBar: NavigationBar(
              selectedIndex: _getCurrentIndex(context),
              onDestinationSelected: (index) =>
                  _onDestinationSelected(context, ref, index),
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.event),
                  label: AppLocalizations.of(context)!.navEvents,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.more_horiz),
                  label: AppLocalizations.of(context)!.more,
                ),
              ],
            ),
            body: child,
          );
        }
      },
    );
  }
}
