import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Título principal de la página del catálogo de componentes
  ///
  /// In es, this message translates to:
  /// **'Catálogo de Componentes'**
  String get titleCatalog;

  /// Texto del menú para acceder a la demostración de botones
  ///
  /// In es, this message translates to:
  /// **'Botones'**
  String get buttonsDemo;

  /// Subtítulo para la demo de botones
  ///
  /// In es, this message translates to:
  /// **'Variantes, estados y tamaños'**
  String get buttonsSubtitle;

  /// Texto del menú para acceder a la demo de insignias
  ///
  /// In es, this message translates to:
  /// **'Insignias'**
  String get badgesDemo;

  /// Subtítulo para la demo de insignias
  ///
  /// In es, this message translates to:
  /// **'Estados y categorías'**
  String get badgesSubtitle;

  /// Título para la página de configuración de la aplicación
  ///
  /// In es, this message translates to:
  /// **'Preferencias'**
  String get preferences;

  /// Opción para activar el modo oscuro
  ///
  /// In es, this message translates to:
  /// **'Modo oscuro'**
  String get darkMode;

  /// Título de la sección para cambiar el idioma
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// Opción para activar o desactivar notificaciones
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notifications;

  /// Título de la sección de badges de filtro
  ///
  /// In es, this message translates to:
  /// **'Badges de filtro'**
  String get badgesFilterTitle;

  /// Filtro: todos los elementos
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get filterAll;

  /// Filtro: música
  ///
  /// In es, this message translates to:
  /// **'Música'**
  String get filterMusic;

  /// Filtro: arte
  ///
  /// In es, this message translates to:
  /// **'Arte'**
  String get filterArt;

  /// Filtro: deportes
  ///
  /// In es, this message translates to:
  /// **'Deportes'**
  String get filterSports;

  /// Título para badges de estado
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get statusTitle;

  /// Título para badges de recompensa
  ///
  /// In es, this message translates to:
  /// **'Recompensa'**
  String get rewardTitle;

  /// Título para badges informativos
  ///
  /// In es, this message translates to:
  /// **'Info'**
  String get infoTitle;

  /// Título para badges de categoría
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get categoryTitle;

  /// Badge de estado activo
  ///
  /// In es, this message translates to:
  /// **'Activo'**
  String get active;

  /// Etiqueta para reviews
  ///
  /// In es, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// Título sección de botones primarios
  ///
  /// In es, this message translates to:
  /// **'Primary (Descargar / Compartir)'**
  String get primaryButtonsTitle;

  /// Texto del botón descargar
  ///
  /// In es, this message translates to:
  /// **'Descargar'**
  String get download;

  /// Texto del botón compartir
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get share;

  /// Título sección botones de peligro
  ///
  /// In es, this message translates to:
  /// **'Danger (Cancelar / Eliminar)'**
  String get dangerButtonsTitle;

  /// Botón para cancelar ticket
  ///
  /// In es, this message translates to:
  /// **'Cancelar entrada'**
  String get cancelTicket;

  /// Texto para botones desactivados
  ///
  /// In es, this message translates to:
  /// **'Desactivado'**
  String get disabled;

  /// Nombre del idioma Español
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// Nombre del idioma Inglés
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get english;

  /// Muestra la cantidad de puntos del usuario
  ///
  /// In es, this message translates to:
  /// **'{value, plural, =0{0 puntos} =1{1 punto} other{{value} puntos}}'**
  String points(num value);

  /// Opción del menú para ver los chips de filtros
  ///
  /// In es, this message translates to:
  /// **'Filtros'**
  String get filterChipsDemo;

  /// Subtítulo para la demo de chips de filtro
  ///
  /// In es, this message translates to:
  /// **'Opciones de filtro seleccionables'**
  String get filterChipsSubtitle;

  /// Título encima de los chips de filtro
  ///
  /// In es, this message translates to:
  /// **'Opciones de filtro'**
  String get filterChipsTitle;

  /// Opción del menú para ver la navegación
  ///
  /// In es, this message translates to:
  /// **'Navegación'**
  String get navigationDemo;

  /// Subtítulo para la demo de navegación
  ///
  /// In es, this message translates to:
  /// **'AppBar y barra inferior'**
  String get navigationDemoSubtitle;

  /// Elemento de navegación inferior: eventos
  ///
  /// In es, this message translates to:
  /// **'Eventos'**
  String get navEvents;

  /// Elemento de navegación inferior: entradas
  ///
  /// In es, this message translates to:
  /// **'Entradas'**
  String get navTickets;

  /// Elemento de navegación inferior: escanear
  ///
  /// In es, this message translates to:
  /// **'Escanear'**
  String get navScan;

  /// Elemento de navegación inferior: explorar
  ///
  /// In es, this message translates to:
  /// **'Explorar'**
  String get navExplore;

  /// Elemento de navegación inferior: perfil
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get navProfile;

  /// Muestra la pestaña seleccionada
  ///
  /// In es, this message translates to:
  /// **'Pestaña actual: {value}'**
  String currentTab(int value);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
