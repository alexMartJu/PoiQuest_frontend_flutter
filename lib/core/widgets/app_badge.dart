import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';

enum AppBadgeVariant { status, reward, info, category }

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

    final (bg, fg) = switch (variant) {
      AppBadgeVariant.status => (c.success, c.onSuccess),
      AppBadgeVariant.reward => (c.warning, c.onWarning),
      AppBadgeVariant.info => (c.surfaceContainer.withValues(alpha: 0.6), c.textPrimary),
      AppBadgeVariant.category => (c.surfaceContainer.withValues(alpha: 0.6), c.textPrimary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
