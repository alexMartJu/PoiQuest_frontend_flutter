import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_main_scaffold.dart';

import 'package:poiquest_frontend_flutter/features/preferences/presentation/pages/preferences_page.dart';
import 'package:poiquest_frontend_flutter/features/events/presentation/pages/events_page.dart';
import 'package:poiquest_frontend_flutter/catalog/catalog_page.dart';

import 'package:poiquest_frontend_flutter/catalog/demos/buttons_demo.dart';
import 'package:poiquest_frontend_flutter/catalog/demos/badges_demo.dart';
import 'package:poiquest_frontend_flutter/catalog/demos/cards_demo.dart';
import 'package:poiquest_frontend_flutter/catalog/demos/filter_chips_demo.dart';
import 'package:poiquest_frontend_flutter/catalog/demos/navigation_demo.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/events',
  routes: [

    // App con pestañas persistentes
    StatefulShellRoute.indexedStack(
      builder: (context, state, navShell) => AppMainScaffold(navigationShell: navShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/events',
              builder: (_, __) => const EventsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tickets',
              builder: (_, __) => const Center(child: Text('Página Tickets')),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/scan',
              builder: (_, __) => const Center(child: Text('Página Scan QR')),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/explore',
              builder: (_, __) => const Center(child: Text('Página Explorar')),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (_, __) => const Center(child: Text('Página Perfil')),
            ),
          ],
        ),
      ],
    ),

    // Rutas fuera del shell
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/preferences',
      builder: (_, __) => const PreferencesPage(),
    ),

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
      ],
    ),
  ],
);
