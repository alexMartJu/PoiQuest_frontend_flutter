import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;

  const AppAppBar({
    super.key,
    this.onNotificationsTap,
    this.onSettingsTap,
    this.onLogoutTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;

    return AppBar(
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: 16),

          // Logo pill
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: c.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: c.onPrimary,
              size: 26,
            ),
          ),

          const SizedBox(width: 8),

          RichText(
            text: TextSpan(
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              children: [
                TextSpan(text: 'Poi', style: TextStyle(color: c.secondary)),
                TextSpan(text: 'Quest', style: TextStyle(color: c.primary)),
              ],
            ),
          ),

          const Spacer(),

          IconButton(
            onPressed: onNotificationsTap,
            icon: Icon(Icons.notifications_none, color: c.primary),
            tooltip: t.notifications,
          ),

          IconButton(
            onPressed: onSettingsTap,
            icon: Icon(Icons.settings_outlined, color: c.primary),
            tooltip: t.preferences,
          ),

          if (onLogoutTap != null)
            IconButton(
              onPressed: onLogoutTap,
              icon: Icon(Icons.logout, color: c.primary),
              tooltip: t.logout,
            ),

          const SizedBox(width: 6),
        ],
      ),
    );
  }
}

