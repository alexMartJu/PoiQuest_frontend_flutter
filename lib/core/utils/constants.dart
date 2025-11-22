import 'package:poiquest_frontend_flutter/core/utils/env.dart';

/// URL base leída desde Env
final baseUrl = Env.apiBaseUrl;

/// Endpoints de eventos
const String eventCategoriesEndpoint = '/event-categories';
String eventsByCategoryEndpoint(String categoryUuid) => '/events/category/$categoryUuid';
const String eventsEndpoint = '/events';

/// Endpoints de autenticación
const String loginEndpoint = '/auth/login';
const String registerStandardUserEndpoint = '/auth/register-standard-user';
const String refreshTokenEndpoint = '/auth/refresh';
const String logoutEndpoint = '/auth/logout';
const String logoutAllEndpoint = '/auth/logout-all';
const String meEndpoint = '/auth/me';

/// Keys para Secure Storage
const String tokenKey = 'auth_token';
const String refreshKey = 'refresh_token';

/// Timeouts
const Duration connectTimeout = Duration(seconds: 10);
const Duration receiveTimeout = Duration(seconds: 10);
