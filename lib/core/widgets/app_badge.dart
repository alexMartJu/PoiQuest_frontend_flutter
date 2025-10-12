import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_palette.dart';

enum AppBadgeVariant {
  filter,
  status,
  reward,
  info,
  category,
}

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeVariant variant;
  final bool selected;
  final VoidCallback? onTap;

  const AppBadge({
    super.key,
    required this.label,
    required this.variant,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = appPaletteOf(context);

    // Colores base por tipo de badge
    final (bg, fg, border) = switch (variant) {
      // Filtros
      AppBadgeVariant.filter => selected
          ? (palette.primary, palette.onPrimary, Colors.transparent)
          : (palette.border.withValues(alpha: 0.5), palette.textPrimary, Colors.transparent),

      // Estado (Activo)
      AppBadgeVariant.status => (palette.secondary, palette.onSecondary, Colors.transparent),

      // Recompensas (+150)
      AppBadgeVariant.reward => (palette.warning, palette.onWarning, Colors.transparent),

      // Información neutral (200 puntos)
      AppBadgeVariant.info => (palette.border.withValues(alpha: 0.5), palette.textPrimary, Colors.transparent),

      // Categorías (Cultura...)
      AppBadgeVariant.category => (palette.border.withValues(alpha: 0.5), palette.textPrimary, Colors.transparent),
    };

    final badge = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1),
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

    // Si es interactivo, lo hacemos clicable
    return onTap != null
        ? GestureDetector(onTap: onTap, child: badge)
        : badge;
  }
}
