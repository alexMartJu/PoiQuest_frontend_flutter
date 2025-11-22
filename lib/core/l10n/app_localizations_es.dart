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

  @override
  String get discoverEvents => 'Descubre Eventos';

  @override
  String get findAmazingEvents => 'Encuentra eventos increíbles cerca de ti';

  @override
  String get featuredEvents => 'Eventos Destacados';

  @override
  String errorLoadingCategories(String error) {
    return 'Error al cargar categorías: $error';
  }

  @override
  String get errorLoadingEvents => 'Error al cargar eventos';

  @override
  String get retry => 'Reintentar';

  @override
  String get noEventsAvailable => 'No hay eventos disponibles';

  @override
  String get tryAnotherCategory => 'Intenta seleccionar otra categoría';

  @override
  String get noMoreEvents => 'No hay más eventos';

  @override
  String get noLocation => 'Sin ubicación';

  @override
  String get allCategories => 'Todas';

  @override
  String get cardsDemo => 'Tarjetas';

  @override
  String get cardsSubtitle => 'Tarjetas de eventos con diseño horizontal';

  @override
  String get cardsDemoTitle => 'Tarjeta de Evento';

  @override
  String get eventTapped => '¡Evento seleccionado!';

  @override
  String get sampleEventTitle => 'Festival de Música de Verano';

  @override
  String get sampleEventLocation => 'Parque Central';

  @override
  String get textFieldsDemo => 'Campos de Texto';

  @override
  String get textFieldsSubtitle => 'Variantes texto, email y password';

  @override
  String get textFieldsTextVariantTitle => 'Variante texto (con y sin icono)';

  @override
  String get textFieldsEmailVariantTitle => 'Variante email (con y sin icono)';

  @override
  String get textFieldsPasswordVariantTitle =>
      'Variante password (con y sin icono)';

  @override
  String get textFieldsDisabledTitle => 'Estado deshabilitado';

  @override
  String get textFieldsNameLabel => 'Nombre';

  @override
  String get textFieldsNameHint => 'Ingresa tu nombre';

  @override
  String get textFieldsEmailLabel => 'Email';

  @override
  String get textFieldsEmailHint => 'tu@email.com';

  @override
  String get textFieldsPasswordLabel => 'Contraseña';

  @override
  String get signInRegister => 'Iniciar sesión / Registrarse';

  @override
  String get exploreWithoutSignIn =>
      'Puedes explorar eventos y POIs sin iniciar sesión';

  @override
  String get signInToViewTickets => 'Inicia sesión para ver tus entradas';

  @override
  String get signInToViewTicketsDesc =>
      'Crea una cuenta o inicia sesión para comprar entradas, gestionar reservas y acceder a tus códigos QR.';

  @override
  String get signInToScanQR => 'Inicia sesión para escanear códigos QR';

  @override
  String get signInToScanQRDesc =>
      'Crea una cuenta o inicia sesión para escanear códigos QR, validar entradas y acceder a contenido exclusivo.';

  @override
  String get signInToYourProfile => 'Inicia sesión en tu perfil';

  @override
  String get signInToYourProfileDesc =>
      'Crea una cuenta para personalizar tu experiencia, gestionar ajustes y ver tu historial de actividad.';

  @override
  String get signInToContinue => 'Inicia sesión para continuar';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'tu@email.com';

  @override
  String get password => 'Contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get name => 'Nombre';

  @override
  String get lastname => 'Apellido';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String welcomeMessage(String name) {
    return '¡Bienvenido a PoiQuest, $name!';
  }

  @override
  String errorLogin(String error) {
    return 'Error al iniciar sesión: $error';
  }

  @override
  String errorRegister(String error) {
    return 'Error al registrar: $error';
  }

  @override
  String get featureInDevelopment => 'Funcionalidad en desarrollo';

  @override
  String get filledButtonsSmall => 'Botones rellenos - Pequeño';

  @override
  String get filledButtonsMedium => 'Botones rellenos - Mediano (Por defecto)';

  @override
  String get filledButtonsLarge => 'Botones rellenos - Grande';

  @override
  String get withoutIcon => 'Sin icono';

  @override
  String get withIcon => 'Con icono';

  @override
  String get loadingState => 'Estado de carga';

  @override
  String get toggleLoading => 'Alternar carga';

  @override
  String get processing => 'Procesando...';

  @override
  String get smallButton => 'Botón pequeño';

  @override
  String get mediumButton => 'Botón mediano';

  @override
  String get largeButton => 'Botón grande';

  @override
  String validatorRequired(String fieldName) {
    return 'Por favor ingresa $fieldName';
  }

  @override
  String get validatorRequiredDefault => 'Por favor ingresa este campo';

  @override
  String get validatorEmailRequired => 'Por favor ingresa tu email';

  @override
  String get validatorEmailInvalid => 'Ingresa un email válido';

  @override
  String validatorEmailMaxLength(int maxLength) {
    return 'El email no puede superar $maxLength caracteres';
  }

  @override
  String get validatorPasswordRequired => 'Por favor ingresa una contraseña';

  @override
  String validatorPasswordMinLength(int minLength) {
    return 'La contraseña debe tener al menos $minLength caracteres';
  }

  @override
  String get validatorPasswordStrong =>
      'Debe incluir minúscula, mayúscula y número';

  @override
  String get validatorConfirmPasswordRequired =>
      'Por favor confirma tu contraseña';

  @override
  String get validatorPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String validatorMaxLength(String fieldName, int maxLength) {
    return '$fieldName no puede superar $maxLength caracteres';
  }

  @override
  String validatorMaxLengthDefault(int maxLength) {
    return 'Este campo no puede superar $maxLength caracteres';
  }

  @override
  String get validatorNameRequired => 'tu nombre';

  @override
  String validatorNameMaxLength(int maxLength) {
    return 'El nombre no puede superar $maxLength caracteres';
  }

  @override
  String get validatorLastnameRequired => 'tus apellidos';

  @override
  String validatorLastnameMaxLength(int maxLength) {
    return 'Los apellidos no pueden superar $maxLength caracteres';
  }
}
