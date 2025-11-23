import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filled_button.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_button.dart';

/// Muestra un diálogo de confirmación reutilizable.
///
/// Retorna `true` si el usuario confirma, `false` si cancela, o `null` si cierra el diálogo sin interactuar.
///
/// Ejemplo de uso:
/// ```dart
/// final confirmed = await AppDialog.showConfirm(
///   context,
///   title: 'Eliminar cuenta',
///   content: 'Esta accion no se puede deshacer.',
///   confirmLabel: 'Eliminar',
///   isDanger: true,
/// );
/// if (confirmed == true) {
///   // Usuario confirmo
/// }
/// ```
class AppDialog {
  /// Muestra un dialogo de confirmacion con botones de Cancelar y Confirmar.
  ///
  /// Parametros:
  /// - [context]: BuildContext requerido.
  /// - [title]: Titulo del dialogo (puede ser String o Widget).
  /// - [content]: Contenido del dialogo (puede ser String o Widget).
  /// - [confirmLabel]: Texto del boton de confirmacion (por defecto "Confirmar").
  /// - [cancelLabel]: Texto del boton de cancelacion (por defecto "Cancelar").
  /// - [isDanger]: Si true, el boton de confirmacion se muestra con estilo de advertencia.
  /// - [barrierDismissible]: Si true, el dialogo se puede cerrar tocando fuera de el.
  /// - [confirmIcon]: Icono opcional para el boton de confirmacion.
  static Future<bool?> showConfirm(
    BuildContext context, {
    required dynamic title,
    required dynamic content,
    String confirmLabel = 'Confirmar',
    String cancelLabel = 'Cancelar',
    bool isDanger = false,
    bool barrierDismissible = true,
    IconData? confirmIcon,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => _AppConfirmDialog(
        title: title,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDanger: isDanger,
        confirmIcon: confirmIcon,
      ),
    );
  }

  /// Muestra un dialogo de alerta simple con un solo boton OK.
  ///
  /// Parametros:
  /// - [context]: BuildContext requerido.
  /// - [title]: Titulo del dialogo (puede ser String o Widget).
  /// - [content]: Contenido del dialogo (puede ser String o Widget).
  /// - [buttonLabel]: Texto del boton (por defecto "OK").
  static Future<void> showAlert(
    BuildContext context, {
    required dynamic title,
    required dynamic content,
    String buttonLabel = 'OK',
  }) {
    return showDialog(
      context: context,
      builder: (context) => _AppAlertDialog(
        title: title,
        content: content,
        buttonLabel: buttonLabel,
      ),
    );
  }
}

/// Widget interno para diálogos de confirmación.
class _AppConfirmDialog extends StatelessWidget {
  final dynamic title;
  final dynamic content;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDanger;
  final IconData? confirmIcon;

  const _AppConfirmDialog({
    required this.title,
    required this.content,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.isDanger,
    this.confirmIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: title is String ? Text(title) : title as Widget,
      content: content is String ? Text(content) : content as Widget,
      actions: [
        AppButton(
          label: cancelLabel,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        // Usamos AppFilledButton para mantener consistencia con el diseño global.
        // En caso de isDanger, pasamos colores explícitos.
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: AppFilledButton(
            label: confirmLabel,
            onPressed: () => Navigator.of(context).pop(true),
            backgroundColor: isDanger ? colorScheme.error : null,
            foregroundColor: isDanger ? colorScheme.onError : null,
          ),
        ),
      ],
    );
  }
}

/// Widget interno para diálogos de alerta simple.
class _AppAlertDialog extends StatelessWidget {
  final dynamic title;
  final dynamic content;
  final String buttonLabel;

  const _AppAlertDialog({
    required this.title,
    required this.content,
    required this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title is String ? Text(title) : title as Widget,
      content: content is String ? Text(content) : content as Widget,
      actions: [
        AppFilledButton(
          label: buttonLabel,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
