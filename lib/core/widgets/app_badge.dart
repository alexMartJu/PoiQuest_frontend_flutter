import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';

enum AppBadgeVariant { status, reward, info, category, filter, primary }

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeVariant variant;

  const AppBadge({
    super.key,
    required this.label,
    required this.variant,
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
    };

    return Container(
      padding: pd,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
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
