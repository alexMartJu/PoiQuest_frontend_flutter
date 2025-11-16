import 'package:poiquest_frontend_flutter/core/utils/env.dart';

/// URL base leída desde Env
final baseUrl = Env.apiBaseUrl;

/// Endpoints de eventos
const String eventCategoriesEndpoint = '/event-categories';
String eventsByCategoryEndpoint(String categoryUuid) => '/events/category/$categoryUuid';
const String eventsEndpoint = '/events';

/// Timeouts
const Duration connectTimeout = Duration(seconds: 10);
const Duration receiveTimeout = Duration(seconds: 10);
