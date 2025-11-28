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

  /// Etiqueta para el menú Más / hoja inferior
  ///
  /// In es, this message translates to:
  /// **'Más'**
  String get more;

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

  /// Título para la sección de descubrimiento de eventos
  ///
  /// In es, this message translates to:
  /// **'Descubre Eventos'**
  String get discoverEvents;

  /// Subtítulo para la sección de descubrimiento de eventos
  ///
  /// In es, this message translates to:
  /// **'Encuentra eventos increíbles cerca de ti'**
  String get findAmazingEvents;

  /// Título para la sección de eventos destacados
  ///
  /// In es, this message translates to:
  /// **'Eventos Destacados'**
  String get featuredEvents;

  /// Mensaje de error cuando las categorías no se cargan
  ///
  /// In es, this message translates to:
  /// **'Error al cargar categorías: {error}'**
  String errorLoadingCategories(String error);

  /// Mensaje de error cuando los eventos no se cargan
  ///
  /// In es, this message translates to:
  /// **'Error al cargar eventos'**
  String get errorLoadingEvents;

  /// Texto del botón para reintentar una acción
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// Mensaje cuando no se encuentran eventos
  ///
  /// In es, this message translates to:
  /// **'No hay eventos disponibles'**
  String get noEventsAvailable;

  /// Sugerencia cuando no se encuentran eventos
  ///
  /// In es, this message translates to:
  /// **'Intenta seleccionar otra categoría'**
  String get tryAnotherCategory;

  /// Mensaje cuando se han cargado todos los eventos
  ///
  /// In es, this message translates to:
  /// **'No hay más eventos'**
  String get noMoreEvents;

  /// Texto mostrado cuando el evento no tiene ubicación
  ///
  /// In es, this message translates to:
  /// **'Sin ubicación'**
  String get noLocation;

  /// Etiqueta del chip de filtro para mostrar todos los eventos sin filtro de categoría
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get allCategories;

  /// Opción del menú para acceder a la demo de tarjetas
  ///
  /// In es, this message translates to:
  /// **'Tarjetas'**
  String get cardsDemo;

  /// Subtítulo para la demo de tarjetas
  ///
  /// In es, this message translates to:
  /// **'Tarjetas de eventos con diseño horizontal'**
  String get cardsSubtitle;

  /// Título para la sección de tarjeta de evento en demo
  ///
  /// In es, this message translates to:
  /// **'Tarjeta de Evento'**
  String get cardsDemoTitle;

  /// Mensaje del snackbar cuando se toca una tarjeta de evento en demo
  ///
  /// In es, this message translates to:
  /// **'¡Evento seleccionado!'**
  String get eventTapped;

  /// Título de evento de ejemplo para tarjeta demo
  ///
  /// In es, this message translates to:
  /// **'Festival de Música de Verano'**
  String get sampleEventTitle;

  /// Ubicación de evento de ejemplo para tarjeta demo
  ///
  /// In es, this message translates to:
  /// **'Parque Central'**
  String get sampleEventLocation;

  /// Opción del menú para acceder a la demostración de campos de texto
  ///
  /// In es, this message translates to:
  /// **'Campos de Texto'**
  String get textFieldsDemo;

  /// Subtítulo para la demo de campos de texto
  ///
  /// In es, this message translates to:
  /// **'Variantes texto, email y password'**
  String get textFieldsSubtitle;

  /// Título para la sección de variante texto en demo de campos
  ///
  /// In es, this message translates to:
  /// **'Variante texto (con y sin icono)'**
  String get textFieldsTextVariantTitle;

  /// Título para la sección de variante email en demo de campos
  ///
  /// In es, this message translates to:
  /// **'Variante email (con y sin icono)'**
  String get textFieldsEmailVariantTitle;

  /// Título para la sección de variante password en demo de campos
  ///
  /// In es, this message translates to:
  /// **'Variante password (con y sin icono)'**
  String get textFieldsPasswordVariantTitle;

  /// Título para la sección de estado deshabilitado en demo de campos
  ///
  /// In es, this message translates to:
  /// **'Estado deshabilitado'**
  String get textFieldsDisabledTitle;

  /// Etiqueta para campo de texto de nombre
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get textFieldsNameLabel;

  /// Hint para campo de texto de nombre
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu nombre'**
  String get textFieldsNameHint;

  /// Etiqueta para campo de texto de email
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get textFieldsEmailLabel;

  /// Hint para campo de texto de email
  ///
  /// In es, this message translates to:
  /// **'tu@email.com'**
  String get textFieldsEmailHint;

  /// Etiqueta para campo de texto de contraseña
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get textFieldsPasswordLabel;

  /// Texto del botón para ir a login/registro
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión / Registrarse'**
  String get signInRegister;

  /// Mensaje informativo sobre uso sin autenticación
  ///
  /// In es, this message translates to:
  /// **'Puedes explorar eventos y POIs sin iniciar sesión'**
  String get exploreWithoutSignIn;

  /// Título de la página de tickets sin autenticar
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión para ver tus entradas'**
  String get signInToViewTickets;

  /// Descripción de la página de tickets sin autenticar
  ///
  /// In es, this message translates to:
  /// **'Crea una cuenta o inicia sesión para comprar entradas, gestionar reservas y acceder a tus códigos QR.'**
  String get signInToViewTicketsDesc;

  /// Título de la página de scan sin autenticar
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión para escanear códigos QR'**
  String get signInToScanQR;

  /// Descripción de la página de scan sin autenticar
  ///
  /// In es, this message translates to:
  /// **'Crea una cuenta o inicia sesión para escanear códigos QR, validar entradas y acceder a contenido exclusivo.'**
  String get signInToScanQRDesc;

  /// Título de la página de perfil sin autenticar
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión en tu perfil'**
  String get signInToYourProfile;

  /// Descripción de la página de perfil sin autenticar
  ///
  /// In es, this message translates to:
  /// **'Crea una cuenta para personalizar tu experiencia, gestionar ajustes y ver tu historial de actividad.'**
  String get signInToYourProfileDesc;

  /// Subtítulo en la página de autenticación
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión para continuar'**
  String get signInToContinue;

  /// Texto de la pestaña de login
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get login;

  /// Texto de la pestaña de registro
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get register;

  /// Etiqueta para campo de email
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get email;

  /// Hint para campo de email
  ///
  /// In es, this message translates to:
  /// **'tu@email.com'**
  String get emailHint;

  /// Etiqueta para campo de contraseña
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// Texto del enlace de contraseña olvidada
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get forgotPassword;

  /// Texto del botón de login
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get signIn;

  /// Etiqueta para campo de nombre
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// Etiqueta para campo de apellido
  ///
  /// In es, this message translates to:
  /// **'Apellido'**
  String get lastname;

  /// Etiqueta para campo de confirmar contraseña
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get confirmPassword;

  /// Mensaje de bienvenida tras login exitoso
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido a PoiQuest, {name}!'**
  String welcomeMessage(String name);

  /// Mensaje de error al iniciar sesión
  ///
  /// In es, this message translates to:
  /// **'Error al iniciar sesión: {error}'**
  String errorLogin(String error);

  /// Mensaje de error al registrar
  ///
  /// In es, this message translates to:
  /// **'Error al registrar: {error}'**
  String errorRegister(String error);

  /// Mensaje para funcionalidad no implementada
  ///
  /// In es, this message translates to:
  /// **'Funcionalidad en desarrollo'**
  String get featureInDevelopment;

  /// Título para botones rellenos pequeños
  ///
  /// In es, this message translates to:
  /// **'Botones rellenos - Pequeño'**
  String get filledButtonsSmall;

  /// Título para botones rellenos medianos
  ///
  /// In es, this message translates to:
  /// **'Botones rellenos - Mediano (Por defecto)'**
  String get filledButtonsMedium;

  /// Título para botones rellenos grandes
  ///
  /// In es, this message translates to:
  /// **'Botones rellenos - Grande'**
  String get filledButtonsLarge;

  /// Etiqueta para botón sin icono
  ///
  /// In es, this message translates to:
  /// **'Sin icono'**
  String get withoutIcon;

  /// Etiqueta para botón con icono
  ///
  /// In es, this message translates to:
  /// **'Con icono'**
  String get withIcon;

  /// Título para sección de estado de carga
  ///
  /// In es, this message translates to:
  /// **'Estado de carga'**
  String get loadingState;

  /// Texto del botón para alternar estado de carga
  ///
  /// In es, this message translates to:
  /// **'Alternar carga'**
  String get toggleLoading;

  /// Texto del botón en estado de carga
  ///
  /// In es, this message translates to:
  /// **'Procesando...'**
  String get processing;

  /// Texto de botón pequeño de ejemplo
  ///
  /// In es, this message translates to:
  /// **'Botón pequeño'**
  String get smallButton;

  /// Texto de botón mediano de ejemplo
  ///
  /// In es, this message translates to:
  /// **'Botón mediano'**
  String get mediumButton;

  /// Texto de botón grande de ejemplo
  ///
  /// In es, this message translates to:
  /// **'Botón grande'**
  String get largeButton;

  /// Mensaje de error cuando un campo requerido está vacío
  ///
  /// In es, this message translates to:
  /// **'Por favor ingresa {fieldName}'**
  String validatorRequired(String fieldName);

  /// Mensaje de error cuando un campo requerido está vacío (sin nombre de campo)
  ///
  /// In es, this message translates to:
  /// **'Por favor ingresa este campo'**
  String get validatorRequiredDefault;

  /// Mensaje de error cuando el email está vacío
  ///
  /// In es, this message translates to:
  /// **'Por favor ingresa tu email'**
  String get validatorEmailRequired;

  /// Mensaje de error cuando el formato del email es inválido
  ///
  /// In es, this message translates to:
  /// **'Ingresa un email válido'**
  String get validatorEmailInvalid;

  /// Mensaje genérico de valor inválido para un campo
  ///
  /// In es, this message translates to:
  /// **'{fieldName} no es válido'**
  String validatorInvalid(String fieldName);

  /// Mensaje de error cuando el email supera la longitud máxima
  ///
  /// In es, this message translates to:
  /// **'El email no puede superar {maxLength} caracteres'**
  String validatorEmailMaxLength(int maxLength);

  /// Mensaje de error cuando la contraseña está vacía
  ///
  /// In es, this message translates to:
  /// **'Por favor ingresa una contraseña'**
  String get validatorPasswordRequired;

  /// Mensaje de error cuando la contraseña es demasiado corta
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos {minLength} caracteres'**
  String validatorPasswordMinLength(int minLength);

  /// Mensaje de error cuando la contraseña no cumple requisitos de seguridad
  ///
  /// In es, this message translates to:
  /// **'Debe incluir minúscula, mayúscula y número'**
  String get validatorPasswordStrong;

  /// Mensaje de error cuando la confirmación de contraseña está vacía
  ///
  /// In es, this message translates to:
  /// **'Por favor confirma tu contraseña'**
  String get validatorConfirmPasswordRequired;

  /// Mensaje de error cuando las contraseñas no coinciden
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get validatorPasswordMismatch;

  /// Mensaje de error cuando un campo supera la longitud máxima
  ///
  /// In es, this message translates to:
  /// **'{fieldName} no puede superar {maxLength} caracteres'**
  String validatorMaxLength(String fieldName, int maxLength);

  /// Mensaje de error cuando un campo supera la longitud máxima (sin nombre de campo)
  ///
  /// In es, this message translates to:
  /// **'Este campo no puede superar {maxLength} caracteres'**
  String validatorMaxLengthDefault(int maxLength);

  /// Texto para el campo nombre en mensaje de error requerido
  ///
  /// In es, this message translates to:
  /// **'tu nombre'**
  String get validatorNameRequired;

  /// Mensaje de error cuando el nombre supera la longitud máxima
  ///
  /// In es, this message translates to:
  /// **'El nombre no puede superar {maxLength} caracteres'**
  String validatorNameMaxLength(int maxLength);

  /// Texto para el campo apellidos en mensaje de error requerido
  ///
  /// In es, this message translates to:
  /// **'tus apellidos'**
  String get validatorLastnameRequired;

  /// Mensaje de error cuando los apellidos superan la longitud máxima
  ///
  /// In es, this message translates to:
  /// **'Los apellidos no pueden superar {maxLength} caracteres'**
  String validatorLastnameMaxLength(int maxLength);

  /// Título para la página de perfil
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profileTitle;

  /// Título para la sección de cuenta
  ///
  /// In es, this message translates to:
  /// **'Cuenta'**
  String get accountTitle;

  /// Título para la sección de sesión
  ///
  /// In es, this message translates to:
  /// **'Sesión'**
  String get sessionTitle;

  /// Botón para editar perfil
  ///
  /// In es, this message translates to:
  /// **'Editar Perfil'**
  String get editProfile;

  /// Subtítulo para la opción de editar perfil
  ///
  /// In es, this message translates to:
  /// **'Actualiza tu información personal'**
  String get editProfileSubtitle;

  /// Botón para cambiar avatar
  ///
  /// In es, this message translates to:
  /// **'Cambiar Avatar'**
  String get changeAvatar;

  /// Subtítulo para la opción de cambiar avatar
  ///
  /// In es, this message translates to:
  /// **'Actualiza tu foto de perfil'**
  String get changeAvatarSubtitle;

  /// Botón para cambiar contraseña
  ///
  /// In es, this message translates to:
  /// **'Cambiar Contraseña'**
  String get changePassword;

  /// Subtítulo para la opción de cambiar contraseña
  ///
  /// In es, this message translates to:
  /// **'Actualiza tu contraseña'**
  String get changePasswordSubtitle;

  /// Botón para cerrar sesión en el dispositivo actual
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get logout;

  /// Subtítulo para la opción de cerrar sesión
  ///
  /// In es, this message translates to:
  /// **'Cierra sesión en este dispositivo'**
  String get logoutSubtitle;

  /// Botón para cerrar sesión en todos los dispositivos
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión en Todos'**
  String get logoutAllDevices;

  /// Subtítulo para la opción de cerrar sesión en todos
  ///
  /// In es, this message translates to:
  /// **'Cierra todas las sesiones en todos lados'**
  String get logoutAllDevicesSubtitle;

  /// Título para el diálogo de confirmación de cerrar sesión
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get logoutDialogTitle;

  /// Contenido para el diálogo de confirmación de cerrar sesión
  ///
  /// In es, this message translates to:
  /// **'¿Deseas cerrar sesión en este dispositivo?'**
  String get logoutDialogContent;

  /// Título para el diálogo de confirmación de cerrar todas las sesiones
  ///
  /// In es, this message translates to:
  /// **'Cerrar Todas las Sesiones'**
  String get logoutAllDialogTitle;

  /// Contenido para el diálogo de confirmación de cerrar todas las sesiones
  ///
  /// In es, this message translates to:
  /// **'¿Deseas cerrar sesión en todos tus dispositivos? Tendrás que iniciar sesión nuevamente en todos ellos.'**
  String get logoutAllDialogContent;

  /// Etiqueta del botón confirmar
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// Etiqueta del botón cancelar
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// Mensaje de error cuando no se puede cargar el perfil
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar el perfil'**
  String get profileLoadError;

  /// Título para error al cargar perfil
  ///
  /// In es, this message translates to:
  /// **'Error al cargar el perfil'**
  String get profileLoadErrorTitle;

  /// Mensaje de error cuando falla cerrar sesión
  ///
  /// In es, this message translates to:
  /// **'Error al cerrar sesión: {error}'**
  String logoutError(String error);

  /// Mensaje de error cuando falla cerrar todas las sesiones
  ///
  /// In es, this message translates to:
  /// **'Error al cerrar sesiones: {error}'**
  String logoutAllError(String error);

  /// Etiqueta para el campo biografía
  ///
  /// In es, this message translates to:
  /// **'Biografía'**
  String get bio;

  /// Pista para el campo biografía
  ///
  /// In es, this message translates to:
  /// **'Cuéntanos sobre ti...'**
  String get bioHint;

  /// Botón para guardar cambios
  ///
  /// In es, this message translates to:
  /// **'Guardar Cambios'**
  String get saveChanges;

  /// Mensaje de éxito cuando se actualiza el perfil
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado con éxito'**
  String get profileUpdatedSuccess;

  /// Mensaje de error cuando falla la actualización del perfil
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar perfil: {error}'**
  String profileUpdateError(String error);

  /// Etiqueta para el campo URL del avatar
  ///
  /// In es, this message translates to:
  /// **'URL del Avatar'**
  String get avatarUrl;

  /// Pista para el campo URL del avatar
  ///
  /// In es, this message translates to:
  /// **'https://ejemplo.com/avatar.jpg'**
  String get avatarUrlHint;

  /// Texto de ayuda para el campo URL del avatar
  ///
  /// In es, this message translates to:
  /// **'Introduce la URL de tu nueva imagen de perfil'**
  String get avatarUrlHelp;

  /// Botón para actualizar avatar
  ///
  /// In es, this message translates to:
  /// **'Actualizar Avatar'**
  String get updateAvatar;

  /// Mensaje de éxito cuando se actualiza el avatar
  ///
  /// In es, this message translates to:
  /// **'Avatar actualizado con éxito'**
  String get avatarUpdatedSuccess;

  /// Mensaje de error cuando falla la actualización del avatar
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar avatar: {error}'**
  String avatarUpdateError(String error);

  /// Etiqueta para el campo contraseña actual
  ///
  /// In es, this message translates to:
  /// **'Contraseña Actual'**
  String get oldPassword;

  /// Etiqueta para el campo nueva contraseña
  ///
  /// In es, this message translates to:
  /// **'Nueva Contraseña'**
  String get newPassword;

  /// Etiqueta para el campo confirmar nueva contraseña
  ///
  /// In es, this message translates to:
  /// **'Confirmar Nueva Contraseña'**
  String get confirmNewPassword;

  /// Título para el diálogo de contraseña actualizada
  ///
  /// In es, this message translates to:
  /// **'Contraseña Actualizada'**
  String get passwordUpdatedTitle;

  /// Contenido para el diálogo de contraseña actualizada
  ///
  /// In es, this message translates to:
  /// **'Se han cerrado todas tus sesiones. Por favor, inicia sesión nuevamente.'**
  String get passwordUpdatedContent;

  /// Mensaje de error cuando falla el cambio de contraseña
  ///
  /// In es, this message translates to:
  /// **'Error al cambiar contraseña'**
  String get passwordChangeError;

  /// Mensaje de error cuando la contraseña actual es incorrecta
  ///
  /// In es, this message translates to:
  /// **'La contraseña actual es incorrecta'**
  String get passwordIncorrect;

  /// Etiqueta del botón Aceptar
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get ok;

  /// Etiqueta del botón para cerrar sesión en todos
  ///
  /// In es, this message translates to:
  /// **'Cerrar en Todos'**
  String get logoutAllButton;

  /// Título de la sección de requisitos de contraseña
  ///
  /// In es, this message translates to:
  /// **'Requisitos de la contraseña:'**
  String get passwordRequirementsTitle;

  /// Requisito de contraseña: longitud mínima
  ///
  /// In es, this message translates to:
  /// **'• Mínimo 12 caracteres'**
  String get passwordRequirementMinLength;

  /// Requisito de contraseña: letra mayúscula
  ///
  /// In es, this message translates to:
  /// **'• Al menos una letra mayúscula'**
  String get passwordRequirementUppercase;

  /// Requisito de contraseña: letra minúscula
  ///
  /// In es, this message translates to:
  /// **'• Al menos una letra minúscula'**
  String get passwordRequirementLowercase;

  /// Requisito de contraseña: número
  ///
  /// In es, this message translates to:
  /// **'• Al menos un número'**
  String get passwordRequirementNumber;

  /// Etiqueta del nivel de usuario
  ///
  /// In es, this message translates to:
  /// **'Nivel {levelNumber}'**
  String level(int levelNumber);

  /// Botón para crear un nuevo evento
  ///
  /// In es, this message translates to:
  /// **'Crear Evento'**
  String get createevent;

  /// Título para editar evento
  ///
  /// In es, this message translates to:
  /// **'Editar Evento'**
  String get editevent;

  /// Etiqueta para campo nombre del evento
  ///
  /// In es, this message translates to:
  /// **'Nombre del Evento'**
  String get eventname;

  /// Etiqueta para campo descripción
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get description;

  /// Etiqueta para campo categoría
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get category;

  /// Etiqueta para campo ubicación
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get location;

  /// Etiqueta para campo fecha de inicio
  ///
  /// In es, this message translates to:
  /// **'Fecha de Inicio'**
  String get startdate;

  /// Etiqueta para campo fecha de fin
  ///
  /// In es, this message translates to:
  /// **'Fecha de Fin'**
  String get enddate;

  /// Etiqueta para campo URL de imagen
  ///
  /// In es, this message translates to:
  /// **'URL de Imagen'**
  String get imageurl;

  /// Mensaje de error cuando no se selecciona categoría
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona una categoría'**
  String get pleaseselectacategory;

  /// Mensaje de error cuando no hay imágenes
  ///
  /// In es, this message translates to:
  /// **'Se requiere al menos una imagen'**
  String get atleastoneimagerequired;

  /// Mensaje de error para URL inválida
  ///
  /// In es, this message translates to:
  /// **'URL inválida'**
  String get invalidurl;

  /// Mensaje de error para campo obligatorio vacío
  ///
  /// In es, this message translates to:
  /// **'Este campo es obligatorio'**
  String get fieldisrequired;

  /// Mensaje de éxito al crear evento
  ///
  /// In es, this message translates to:
  /// **'Evento creado exitosamente'**
  String get eventcreatedsuccessfully;

  /// Mensaje de éxito al actualizar evento
  ///
  /// In es, this message translates to:
  /// **'Evento actualizado exitosamente'**
  String get eventupdatedsuccessfully;

  /// Mensaje de éxito al eliminar evento
  ///
  /// In es, this message translates to:
  /// **'Evento eliminado exitosamente'**
  String get eventdeletedsuccessfully;

  /// Botón crear
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get create;

  /// Botón guardar
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// Título para confirmar eliminación de evento
  ///
  /// In es, this message translates to:
  /// **'Eliminar Evento'**
  String get deleteevent;

  /// Mensaje de confirmación para eliminar evento
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas eliminar este evento? Esta acción no se puede deshacer.'**
  String get deleteeventconfirm;

  /// Botón eliminar
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// Título para listado de eventos activos
  ///
  /// In es, this message translates to:
  /// **'Eventos Activos'**
  String get activeevents;

  /// Subtítulo para gestión de eventos
  ///
  /// In es, this message translates to:
  /// **'Gestiona tus eventos'**
  String get manageevents;

  /// Pista mostrada cuando el admin no tiene eventos - indica usar el FAB para crear uno
  ///
  /// In es, this message translates to:
  /// **'Crea tu primer evento con el botón +'**
  String get adminCreateFirstEventHint;
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
