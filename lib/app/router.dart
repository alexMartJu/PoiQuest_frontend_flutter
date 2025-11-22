import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:poiquest_frontend_flutter/features/preferences/presentation/pages/preferences_page.dart';
import 'package:poiquest_frontend_flutter/features/events/presentation/pages/events_page.dart';
import 'package:poiquest_frontend_flutter/catalog/catalog_page.dart';

import 'package:poiquest_frontend_flutter/catalog/demos/buttons_demo.dart';
import 'package:poiquest_frontend_flutter/catalog/demos/badges_demo.dart';
import 'package:poiquest_frontend_flutter/catalog/demos/cards_demo.dart';
import 'package:poiquest_frontend_flutter/catalog/demos/filter_chips_demo.dart';
import 'package:poiquest_frontend_flutter/catalog/demos/navigation_demo.dart';
import 'package:poiquest_frontend_flutter/catalog/demos/text_fields_demo.dart';

// Auth pages
import 'package:poiquest_frontend_flutter/features/auth/presentation/pages/auth_page.dart';
import 'package:poiquest_frontend_flutter/features/auth/presentation/providers/auth_provider.dart';

// Profile pages
import 'package:poiquest_frontend_flutter/features/profile/presentation/pages/profile_page_noauth.dart';

// Tickets pages
import 'package:poiquest_frontend_flutter/features/tickets/presentation/pages/tickets_page_noauth.dart';

// Scan pages
import 'package:poiquest_frontend_flutter/features/scan/presentation/pages/scan_page_noauth.dart';

// Layout
import 'package:poiquest_frontend_flutter/core/widgets/app_main_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Provider del router para acceder al estado de autenticación.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/events',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppMainScaffold(child: child),
        routes: [
          // Ruta de eventos (pública)
          GoRoute(
            path: '/events',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: EventsPage(),
            ),
          ),

          // Ruta de tickets (requiere autenticación)
          GoRoute(
            path: '/tickets',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _AuthCheck(
                logged: Center(child: Text('Página Tickets Autenticada')),
                anonymous: TicketsPageNoAuth(),
              ),
            ),
          ),

          // Ruta de scan (requiere autenticación)
          GoRoute(
            path: '/scan',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _AuthCheck(
                logged: Center(child: Text('Página Scan Autenticada')),
                anonymous: ScanPageNoAuth(),
              ),
            ),
          ),

          // Ruta de explorar (pública)
          GoRoute(
            path: '/explore',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: Center(child: Text('Página Explorar')),
            ),
          ),

          // Ruta de perfil (requiere autenticación)
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _AuthCheck(
                logged: Center(child: Text('Página Profile Autenticada')),
                anonymous: ProfilePageNoAuth(),
              ),
            ),
          ),
        ],
      ),

      // Ruta de autenticación (fuera del shell)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/auth/login',
        builder: (_, __) => const AuthPage(),
      ),

      // Ruta de preferencias (fuera del shell)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/preferences',
        builder: (_, __) => const PreferencesPage(),
      ),

      // Ruta de catálogo (fuera del shell)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/catalog',
        builder: (_, __) => const CatalogPage(),
        routes: [
          GoRoute(
            path: 'buttons',
            builder: (_, __) => const ButtonsDemo(),
          ),
          GoRoute(
            path: 'badges',
            builder: (_, __) => const BadgesDemo(),
          ),
          GoRoute(
            path: 'cards',
            builder: (_, __) => const CardsDemo(),
          ),
          GoRoute(
            path: 'filters',
            builder: (_, __) => const FilterChipsDemo(),
          ),
          GoRoute(
            path: 'navigation',
            builder: (_, __) => const NavigationDemo(),
          ),
          GoRoute(
            path: 'textfields',
            builder: (_, __) => const TextFieldsDemo(),
          ),
        ],
      ),
    ],
  );
});

/// Widget que decide qué mostrar en función del estado de autenticación
class _AuthGate extends ConsumerWidget {
  const _AuthGate({
    required this.logged,
    required this.anonymous,
  });

  final Widget logged;
  final Widget anonymous;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return auth.when(
      data: (user) {
        final isLogged = user != null;
        return isLogged ? logged : anonymous;
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => anonymous,
    );
  }
}

/// Widget que fuerza una comprobación de perfil al entrar en la página.
///
/// Llama a `reloadProfile()` en el `AuthProvider` y espera el resultado. Si
/// el refresh falla (p. ej. token expirado y refresh fallido) el interceptor
/// limpiará los tokens y el `AuthProvider` se actualizará gracias al
/// `AppService.onSessionExpired` que ya registramos.
class _AuthCheck extends ConsumerStatefulWidget {
  const _AuthCheck({
    required this.logged,
    required this.anonymous,
  });

  final Widget logged;
  final Widget anonymous;

  @override
  ConsumerState<_AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends ConsumerState<_AuthCheck> {
  late Future<void> _checkFuture;

  @override
  void initState() {
    super.initState();
    // Forzar recarga del perfil (dispara petición a /auth/me o similar)
    _checkFuture = ref.read(authProvider.notifier).reloadProfile().then((_) {}).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _checkFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final auth = ref.watch(authProvider);
        return auth.when(
          data: (user) => user != null ? widget.logged : widget.anonymous,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => widget.anonymous,
        );
      },
    );
  }
}
