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
import 'package:poiquest_frontend_flutter/features/auth/domain/entities/user.dart';

// Profile pages
import 'package:poiquest_frontend_flutter/features/profile/presentation/pages/profile_page_noauth.dart';
import 'package:poiquest_frontend_flutter/features/profile/presentation/pages/profile_page.dart';
import 'package:poiquest_frontend_flutter/features/profile/presentation/pages/profile_edit_profile_page.dart';
import 'package:poiquest_frontend_flutter/features/profile/presentation/pages/profile_change_avatar_page.dart';
import 'package:poiquest_frontend_flutter/features/profile/presentation/pages/profile_change_password_page.dart';

// Tickets pages
import 'package:poiquest_frontend_flutter/features/tickets/presentation/pages/tickets_page_noauth.dart';

// Scan pages
import 'package:poiquest_frontend_flutter/features/scan/presentation/pages/scan_page_noauth.dart';

// Admin pages
import 'package:poiquest_frontend_flutter/features/admin/presentation/pages/admin_events_page.dart';

// Layout
import 'package:poiquest_frontend_flutter/core/widgets/app_main_scaffold.dart';
import 'package:poiquest_frontend_flutter/core/widgets/admin_main_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Clase para hacer que GoRouter escuche cambios en el authProvider
class _GoRouterRefreshNotifier extends ChangeNotifier {
  _GoRouterRefreshNotifier(this._ref) {
    // Escuchar cambios en authProvider, pero notificar solo cuando importe:
    // - login/logout (cambio de userId)
    // - cambio en los roles del usuario
    _ref.listen<AsyncValue<User?>>(authProvider, (previous, next) {
      final prevUser = previous?.asData?.value;
      final nextUser = next.asData?.value;

      final prevId = prevUser?.userId;
      final nextId = nextUser?.userId;

      final prevRolesSet = (prevUser?.roles ?? <String>[])
          .map((r) => r.toLowerCase().trim())
          .toSet();
      final nextRolesSet = (nextUser?.roles ?? <String>[])
          .map((r) => r.toLowerCase().trim())
          .toSet();

      final idChanged = prevId != nextId;
      final rolesChanged = prevRolesSet.length != nextRolesSet.length || !prevRolesSet.containsAll(nextRolesSet);

      if (idChanged || rolesChanged) {
        notifyListeners();
      }
    });
  }

  final Ref _ref;
}

/// Widget que resuelve el estado inicial y redirige según el rol del usuario.
class _RootRedirector extends ConsumerWidget {
  const _RootRedirector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return auth.when(
      data: (user) {
        // Navegar una vez el frame esté montado para evitar side-effects en build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (user != null) {
            final roles = user.roles.map((r) => r.toLowerCase()).toList();
            if (roles.contains('admin')) {
              context.go('/admin/events');
              return;
            }
          }
          // Por defecto llevar a la parte pública de events
          context.go('/events');
        });

        // Mostrar placeholder breve
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) {
        // En caso de error, dirigir a /events
        WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/events'));
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

/// Provider del router para acceder al estado de autenticación.
final appRouterProvider = Provider<GoRouter>((ref) {
  
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    // Iniciar en ruta raíz que decidirá la navegación según authProvider
    initialLocation: '/',
    refreshListenable: _GoRouterRefreshNotifier(ref),
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final user = authState.value;
      final isLoggedIn = user != null;
      // Normalizar roles para hacer la comprobación case-insensitive
      final roles = isLoggedIn ? user.roles.map((r) => r.toLowerCase()).toList() : <String>[];
      final isAdmin = roles.contains('admin');
      final isUser = roles.contains('user');
      
      final location = state.uri.path;
      final isAdminRoute = location.startsWith('/admin');
      final isUserRoute = ['/events', '/tickets', '/scan', '/explore', '/profile'].any((route) => location.startsWith(route));
      final isPublicRoute = location.startsWith('/auth') || location.startsWith('/catalog') || location.startsWith('/preferences') || location.startsWith('/profile/');
      
      // Si es una ruta pública, permitir acceso
      if (isPublicRoute) {
        return null;
      }
      
      // Si es ADMIN intentando acceder a rutas USER, redirigir a admin
      if (isAdmin && isUserRoute) {
        return '/admin/events';
      }
      
      // Si es USER intentando acceder a rutas ADMIN, redirigir a events
      if (isUser && isAdminRoute) {
        return '/events';
      }
      
      // Permitir navegación normal
      return null;
    },
    routes: [
      // Ruta raíz: espera al estado de autenticación y redirige según el rol
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/',
        builder: (context, state) => const _RootRedirector(),
      ),
      // Shell USER: rutas accesibles para usuarios normales
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
              child: _AuthGate(
                logged: ProfilePage(),
                anonymous: ProfilePageNoAuth(),
              ),
            ),
          ),
        ],
      ),

      // Shell ADMIN: rutas accesibles solo para administradores
      ShellRoute(
        builder: (context, state, child) => AdminMainScaffold(child: child),
        routes: [
          // Ruta de gestión de eventos para admin
          GoRoute(
            path: '/admin/events',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AdminEventsPage(),
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

      // Rutas de perfil (fuera del shell)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/profile/edit',
        builder: (_, __) => const ProfileEditProfilePage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/profile/change-avatar',
        builder: (_, __) => const ProfileChangeAvatarPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/profile/change-password',
        builder: (_, __) => const ProfileChangePasswordPage(),
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
