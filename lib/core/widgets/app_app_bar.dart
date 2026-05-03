import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;
  final int unreadCount;

  const AppAppBar({
    super.key,
    this.onNotificationsTap,
    this.onSettingsTap,
    this.onLogoutTap,
    this.unreadCount = 0,
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

          // Logo
          SizedBox(
            width: 46,
            height: 46,
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'assets/images/app_logo_dark.png'
                  : 'assets/images/app_logo_light.png',
              fit: BoxFit.contain,
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

          // Bell icon with badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: onNotificationsTap,
                icon: Icon(Icons.notifications_none, color: c.primary),
                tooltip: t.notifications,
              ),
              if (unreadCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      decoration: BoxDecoration(
                        color: c.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        unreadCount > 99 ? '99+' : '$unreadCount',
                        style: TextStyle(
                          color: c.onSecondary,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
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

