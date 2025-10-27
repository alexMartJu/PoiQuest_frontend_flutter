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
    final (bg, fg, border) = _colorsForBadge(variant, palette, selected);

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

// Función privada: lógica interna de colores
(Color, Color, Color) _colorsForBadge(
  AppBadgeVariant variant,
  AppPalette palette,
  bool selected,
) {
  return switch (variant) {
    AppBadgeVariant.filter => selected
        ? (palette.primary, palette.onPrimary, Colors.transparent)
        : (palette.border.withValues(alpha: 0.5), palette.textPrimary,
            Colors.transparent),
    AppBadgeVariant.status =>
        (palette.secondary, palette.onSecondary, Colors.transparent),
    AppBadgeVariant.reward =>
        (palette.warning, palette.onWarning, Colors.transparent),
    AppBadgeVariant.info => (
        palette.border.withValues(alpha: 0.5),
        palette.textPrimary,
        Colors.transparent,
      ),
    AppBadgeVariant.category => (
        palette.border.withValues(alpha: 0.5),
        palette.textPrimary,
        Colors.transparent,
      ),
  };
}
