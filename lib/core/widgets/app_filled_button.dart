import 'package:flutter/material.dart';

/// Variantes de tamaño para AppFilledButton.
enum AppFilledButtonSize {
  small,
  medium,
  large,
}

/// Widget reutilizable de botón filled con variantes de tamaño.
/// 
/// Soporta iconos opcionales y mantiene consistencia visual con el Design System.
class AppFilledButton extends StatelessWidget {
  /// Texto del botón.
  final String label;
  
  /// Callback al presionar el botón.
  final VoidCallback? onPressed;
  
  /// Tamaño del botón (small, medium, large).
  final AppFilledButtonSize size;
  
  /// Icono opcional que se muestra a la izquierda del texto.
  final IconData? icon;
  
  /// Color de fondo opcional para el botón. Si se proporciona, se aplicará sobre el estilo por defecto.
  final Color? backgroundColor;
  
  /// Color de primer plano opcional para el botón (texto/iconos). Si se proporciona, se aplicará sobre el estilo por defecto.
  final Color? foregroundColor;
  
  /// Si está en estado de carga (muestra CircularProgressIndicator).
  final bool loading;

  const AppFilledButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = AppFilledButtonSize.medium,
    this.icon,
    this.loading = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Configuración según tamaño (solo cambia el ancho, no la altura)
    final (verticalPadding, horizontalPadding, fontSize, iconSize) = switch (size) {
      AppFilledButtonSize.small => (16.0, 16.0, 14.0, 20.0),
      AppFilledButtonSize.medium => (16.0, 32.0, 14.0, 20.0),
      AppFilledButtonSize.large => (16.0, 48.0, 14.0, 20.0),
    };

    final baseStyle = FilledButton.styleFrom(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      minimumSize: const Size(0, 52), // Altura fija de 52px
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      ),
    );
    // Si se pasan colores explícitos, los aplicamos sobre el estilo base.
    final ButtonStyle buttonStyle = (backgroundColor != null || foregroundColor != null)
      ? baseStyle.copyWith(
        backgroundColor: backgroundColor != null
          ? WidgetStateProperty.all(backgroundColor)
          : null,
        foregroundColor: foregroundColor != null
          ? WidgetStateProperty.all(foregroundColor)
          : null,
        )
      : baseStyle;
    // Widget de contenido (texto o loading indicator)
    Widget content;
    if (loading) {
      content = SizedBox(
        height: 20.0,
        width: 20.0,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: theme.colorScheme.onPrimary,
        ),
      );
    } else if (icon != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize),
          const SizedBox(width: 8),
          Flexible(child: Text(label)),
        ],
      );
    } else {
      content = Text(label);
    }

    return FilledButton(
      onPressed: loading ? null : onPressed,
      style: buttonStyle,
      child: content,
    );
  }
}
