// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get titleCatalog => 'Catálogo de Componentes';

  @override
  String get buttonsDemo => 'Botones';

  @override
  String get buttonsSubtitle => 'Variantes, estados y tamaños';

  @override
  String get badgesDemo => 'Insignias';

  @override
  String get badgesSubtitle => 'Estados y categorías';

  @override
  String get preferences => 'Preferencias';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get badgesFilterTitle => 'Badges de filtro';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterMusic => 'Música';

  @override
  String get filterArt => 'Arte';

  @override
  String get filterSports => 'Deportes';

  @override
  String get statusTitle => 'Estado';

  @override
  String get rewardTitle => 'Recompensa';

  @override
  String get infoTitle => 'Info';

  @override
  String get categoryTitle => 'Categoría';

  @override
  String get active => 'Activo';

  @override
  String get reviews => 'Reviews';

  @override
  String get primaryButtonsTitle => 'Primary (Descargar / Compartir)';

  @override
  String get download => 'Descargar';

  @override
  String get share => 'Compartir';

  @override
  String get dangerButtonsTitle => 'Danger (Cancelar / Eliminar)';

  @override
  String get cancelTicket => 'Cancelar entrada';

  @override
  String get disabled => 'Desactivado';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'Inglés';

  @override
  String points(num value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value puntos',
      one: '1 punto',
      zero: '0 puntos',
    );
    return '$_temp0';
  }

  @override
  String get filterChipsDemo => 'Filtros';

  @override
  String get filterChipsSubtitle => 'Opciones de filtro seleccionables';

  @override
  String get filterChipsTitle => 'Opciones de filtro';

  @override
  String get navigationDemo => 'Navegación';

  @override
  String get navigationDemoSubtitle => 'AppBar y barra inferior';

  @override
  String get navEvents => 'Eventos';

  @override
  String get navTickets => 'Entradas';

  @override
  String get navScan => 'Escanear';

  @override
  String get navExplore => 'Explorar';

  @override
  String get navProfile => 'Perfil';

  @override
  String currentTab(int value) {
    return 'Pestaña actual: $value';
  }
}
