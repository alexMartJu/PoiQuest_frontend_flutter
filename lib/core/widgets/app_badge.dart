import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';

enum AppBadgeVariant {
  status,
  reward,
  info,
  category,
  filter,
  primary,
  danger,
  neutral,
  exploreUnlocked,
  exploreCompleted,
  exploreLocked,
}

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeVariant variant;

  /// Icono opcional que se muestra a la izquierda del texto.
  final IconData? icon;

  const AppBadge({
    super.key,
    required this.label,
    required this.variant,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    final (bg, fg, pd, fs) = switch (variant) {
      AppBadgeVariant.status => (c.success, c.onSuccess, const EdgeInsets.symmetric(horizontal: 12, vertical: 6), 13.0),
      AppBadgeVariant.reward => (c.warning, c.onWarning, const EdgeInsets.symmetric(horizontal: 12, vertical: 6), 13.0),
      AppBadgeVariant.info => (c.surfaceContainer.withValues(alpha: 0.6), c.textPrimary, const EdgeInsets.symmetric(horizontal: 12, vertical: 6), 13.0),
      AppBadgeVariant.category => (c.surfaceContainer.withValues(alpha: 0.6), c.textPrimary, const EdgeInsets.symmetric(horizontal: 12, vertical: 6), 13.0),
      AppBadgeVariant.filter => (c.secondary, c.primary, const EdgeInsets.symmetric(horizontal: 6, vertical: 2), 10.0),
      AppBadgeVariant.primary => (c.primary, c.onPrimary, const EdgeInsets.symmetric(horizontal: 12, vertical: 6), 13.0),
      AppBadgeVariant.danger => (c.error, c.onError, const EdgeInsets.symmetric(horizontal: 12, vertical: 6), 13.0),
      AppBadgeVariant.neutral => (c.surfaceContainer, c.textSecondary, const EdgeInsets.symmetric(horizontal: 12, vertical: 6), 13.0),
      AppBadgeVariant.exploreUnlocked => (c.success.withValues(alpha: 0.1), c.success, const EdgeInsets.symmetric(horizontal: 10, vertical: 4), 11.0),
      AppBadgeVariant.exploreCompleted => (c.primary.withValues(alpha: 0.1), c.primary, const EdgeInsets.symmetric(horizontal: 10, vertical: 4), 11.0),
      AppBadgeVariant.exploreLocked => (c.warning.withValues(alpha: 0.15), c.warning, const EdgeInsets.symmetric(horizontal: 10, vertical: 4), 11.0),
    };

    return Container(
      padding: pd,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: fg),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w600,
                    fontSize: fs,
                  ),
                ),
              ],
            )
          : Text(
              label,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w600,
                fontSize: fs,
              ),
            ),
    );
  }
}
