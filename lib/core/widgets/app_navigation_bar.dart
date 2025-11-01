import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.event_outlined),
          selectedIcon: const Icon(Icons.event),
          label: t.navEvents,
        ),
        NavigationDestination(
          icon: const Icon(Icons.confirmation_number_outlined),
          selectedIcon: const Icon(Icons.confirmation_number),
          label: t.navTickets,
        ),
        NavigationDestination(
          icon: const Icon(Icons.qr_code_scanner),
          selectedIcon: const Icon(Icons.qr_code_scanner),
          label: t.navScan,
        ),
        NavigationDestination(
          icon: const Icon(Icons.travel_explore_outlined),
          selectedIcon: const Icon(Icons.travel_explore),
          label: t.navExplore,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: t.navProfile,
        ),
      ],
    );
  }
}
