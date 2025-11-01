import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';

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
    final c = Theme.of(context).colorScheme;

    final (bg, fg, border) = switch (variant) {
      AppButtonVariant.primary =>
          (c.surfaceContainerHigh, c.textPrimary, c.border),

      AppButtonVariant.danger =>
          (c.error, c.onError, Colors.transparent),
    };

    final (finalBg, finalFg, finalBorder) = disabled
        ? (
            c.border.withValues(alpha: 0.4),
            c.textSecondary.withValues(alpha: 0.5),
            c.border.withValues(alpha: 0.4),
          )
        : (bg, fg, border);

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: finalBg,
        foregroundColor: finalFg,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: finalBorder, width: 1.4),
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
