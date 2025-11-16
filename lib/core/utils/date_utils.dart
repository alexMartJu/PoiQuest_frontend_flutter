import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Utilidades de fecha centralizadas.
///
/// Formatean fechas usando la locale del [context] para mostrar
/// en el idioma seleccionado por el usuario (español/inglés).
///
/// Versión que usa la locale del [context].
/// Muestra fechas en el idioma seleccionado por el usuario.
String formatDateLongFromIsoWithContext(BuildContext context, String dateStr) {
  try {
    final date = DateTime.parse(dateStr);
    return formatDateLongWithContext(context, date);
  } catch (e) {
    return dateStr;
  }
}

String formatDateLongWithContext(BuildContext context, DateTime date) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.yMMMd(locale).format(date);
}
