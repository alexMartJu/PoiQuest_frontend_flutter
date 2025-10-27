import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_palette.dart';

// Solo dos variantes: primary (Download / Share) y danger (acciones negativas)
enum AppButtonVariant { primary, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool disabled;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = appPaletteOf(context);
    final (bg, fg, border) = _colorsForVariant(variant, palette, disabled);

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: border, width: 1.4),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      onPressed: disabled ? null : onPressed,
      child: Text(label),
    );
  }
}

// Función privada: lógica interna de colores
(Color, Color, Color) _colorsForVariant(
  AppButtonVariant variant,
  AppPalette palette,
  bool disabled,
) {
  final (bg, fg, border) = switch (variant) {
    AppButtonVariant.primary =>
        (palette.surface, palette.textPrimary, palette.border),
    AppButtonVariant.danger =>
        (palette.danger, palette.onDanger, Colors.transparent),
  };

  if (disabled) {
    return (
      palette.border.withValues(alpha: 0.5),
      palette.textSecondary.withValues(alpha: 0.6),
      palette.border.withValues(alpha: 0.5),
    );
  }

  return (bg, fg, border);
}
