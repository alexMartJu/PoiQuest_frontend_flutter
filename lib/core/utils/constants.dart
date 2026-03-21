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
