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

    // Colores base según variante
    final (bg, fg, border) = switch (variant) {
      // Primary: fondo blanco, borde gris, texto gris oscuro
      AppButtonVariant.primary => (palette.surface, palette.textPrimary, palette.border),
      // Danger: fondo rojo, texto blanco
      AppButtonVariant.danger => (palette.danger, palette.onDanger, Colors.transparent),
    };

    // Estado deshabilitado
    final effectiveBg = disabled ? palette.border.withValues(alpha: 0.5) : bg;
    final effectiveFg = disabled ? palette.textSecondary.withValues(alpha: 0.6) : fg;
    final effectiveBorder = disabled ? palette.border.withValues(alpha: 0.5) : border;

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: effectiveBg,
        foregroundColor: effectiveFg,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: effectiveBorder, width: 1.4),
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


