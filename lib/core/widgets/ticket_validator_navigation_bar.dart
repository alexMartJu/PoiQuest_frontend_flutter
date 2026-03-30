import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

class TicketValidatorNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const TicketValidatorNavigationBar({
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
          icon: const Icon(Icons.qr_code_scanner_outlined),
          selectedIcon: const Icon(Icons.qr_code_scanner),
          label: t.navValidatorScan,
        ),
        NavigationDestination(
          icon: const Icon(Icons.history_outlined),
          selectedIcon: const Icon(Icons.history),
          label: t.navValidatorHistory,
        ),
      ],
    );
  }
}
