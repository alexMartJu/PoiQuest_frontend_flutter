import 'package:poiquest_frontend_flutter/core/utils/env.dart';

/// URL base leída desde Env
final baseUrl = Env.apiBaseUrl;

/// Endpoints de eventos
const String eventCategoriesEndpoint = '/event-categories';
String eventsByCategoryEndpoint(String categoryUuid) => '/events/category/$categoryUuid';
const String eventsEndpoint = '/events';
String eventDetailEndpoint(String uuid) => '/events/$uuid';

/// Endpoint para obtener el rango de precios de eventos activos
const String eventsPriceRangeEndpoint = '/events/price-range';

/// Endpoints de puntos de interés
String poiDetailEndpoint(String uuid) => '/points-of-interest/$uuid';

/// Endpoints de rutas
String routeDetailEndpoint(String uuid) => '/routes/$uuid';

/// Endpoints de ciudades
const String citiesEndpoint = '/cities';

/// Endpoints de autenticación
const String loginEndpoint = '/auth/login';
const String registerStandardUserEndpoint = '/auth/register-standard-user';
const String refreshTokenEndpoint = '/auth/refresh';
const String logoutEndpoint = '/auth/logout';
const String logoutAllEndpoint = '/auth/logout-all';
const String meEndpoint = '/auth/me';
const String changePasswordEndpoint = '/auth/change-password';

/// Endpoints de perfil
const String profileMeEndpoint = '/profile/me';
const String profileMeAvatarEndpoint = '/profile/me/avatar';

/// Keys para Secure Storage
const String tokenKey = 'auth_token';
const String refreshKey = 'refresh_token';

/// Timeouts
const Duration connectTimeout = Duration(seconds: 10);
const Duration receiveTimeout = Duration(seconds: 10);

/// Endpoints de pagos y tickets
const String createPaymentIntentEndpoint = '/payments/create-payment-intent';
const String confirmPaymentEndpoint = '/payments/confirm-payment';
const String createFreeTicketsEndpoint = '/payments/free-tickets';
const String activeTicketsEndpoint = '/payments/my-tickets/active';
const String usedTicketsEndpoint = '/payments/my-tickets/used';
String eventAvailabilityEndpoint(String eventUuid, String visitDate) =>
    '/payments/availability?eventUuid=$eventUuid&visitDate=$visitDate';

/// Endpoints de validación de tickets (ticket_validator)
const String validateTicketEndpoint = '/ticket-validation/validate';
const String validationHistoryEndpoint = '/ticket-validation/history';

/// Endpoints de exploración
const String exploreMyEventsEndpoint = '/explore/my-events';
String exploreEventProgressEndpoint(String eventUuid) =>
    '/explore/events/$eventUuid/progress';
const String exploreScanPoiEndpoint = '/explore/scan-poi';
String exploreRouteNavigationEndpoint(String routeUuid) =>
    '/explore/routes/$routeUuid/navigation';

/// Endpoints de gamificación
const String gamificationProgressEndpoint = '/gamification/my-progress';
