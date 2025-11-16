import 'package:flutter/material.dart';

/// Widget base reutilizable para cards en la aplicación.
/// 
/// Lee el [CardTheme] del tema actual y permite overrides específicos.
/// Soporta composición flexible con [leading] (imagen/icono) y [child] (contenido).
class AppCard extends StatelessWidget {
  /// Widget opcional a mostrar en el lado izquierdo (imagen, avatar, icono)
  final Widget? leading;
  
  /// Contenido principal de la card
  final Widget child;
  
  /// Callback cuando se toca la card
  final VoidCallback? onTap;
  
  /// Altura fija de la card (opcional)
  final double? height;
  
  /// Padding interno del contenido (si no se especifica, usa EdgeInsets.all(12))
  final EdgeInsetsGeometry? padding;
  
  /// Override del shape por defecto del CardTheme (opcional)
  final ShapeBorder? overrideShape;

  const AppCard({
    super.key,
    this.leading,
    required this.child,
    this.onTap,
    this.height,
    this.padding,
    this.overrideShape,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme = theme.cardTheme;
    
    // Usa el shape del tema o el override local
    final shape = overrideShape ?? cardTheme.shape ?? 
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

    return Card(
      shape: shape,
      margin: cardTheme.margin,
      color: cardTheme.color ?? theme.colorScheme.surface,
      elevation: cardTheme.elevation ?? 0,
      clipBehavior: cardTheme.clipBehavior ?? Clip.none,
      surfaceTintColor: cardTheme.surfaceTintColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: _extractBorderRadius(shape),
        child: SizedBox(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (leading != null)
                ClipRRect(
                  borderRadius: _getLeadingBorderRadius(shape),
                  child: leading!,
                ),
              Expanded(
                child: Padding(
                  padding: padding ?? const EdgeInsets.all(12),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Extrae el BorderRadius del shape para el InkWell
  BorderRadius? _extractBorderRadius(ShapeBorder shape) {
    if (shape is RoundedRectangleBorder && shape.borderRadius is BorderRadius) {
      return shape.borderRadius as BorderRadius;
    }
    return null;
  }

  /// Obtiene el BorderRadius para el leading (solo lado izquierdo)
  BorderRadius _getLeadingBorderRadius(ShapeBorder shape) {
    if (shape is RoundedRectangleBorder && shape.borderRadius is BorderRadius) {
      final br = shape.borderRadius as BorderRadius;
      return BorderRadius.horizontal(left: br.topLeft);
    }
    return const BorderRadius.horizontal(left: Radius.circular(10));
  }
}
