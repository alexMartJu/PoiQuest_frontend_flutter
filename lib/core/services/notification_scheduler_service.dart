import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Servicio singleton para gestionar notificaciones locales.
///
/// - Inicializar con [NotificationSchedulerService.init()] en [main()].
/// - Programar un recordatorio de evento con [scheduleEventReminder].
class NotificationSchedulerService {
  NotificationSchedulerService._();
  static final NotificationSchedulerService instance =
      NotificationSchedulerService._();

  static const _channelId = 'poiquest_events';
  static const _channelName = 'Eventos PoisQuest';
  static const _channelDescription =
      'Recordatorios de eventos comprados en PoisQuest';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    // Inicializar base de datos de zonas horarias
    tz.initializeTimeZones();
    final localTz = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTz));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  /// Solicita permisos de notificación al usuario (Android 13+).
  Future<bool> requestPermissions() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    return true;
  }

  /// Programa una notificación a las 8:00 AM del día del evento.
  ///
  /// Si la fecha del evento es hoy o pasada, no programa nada.
  /// El [notificationId] debería ser único por ticket.
  /// [title] y [body] deben ser cadenas ya traducidas (obtenidas desde el contexto).
  Future<void> scheduleEventReminder({
    required int notificationId,
    required String eventTitle,
    required DateTime eventDate,
    required String title,
    required String body,
  }) async {
    if (!_initialized) await init();

    // Programar para las 8 AM del día del evento en la zona local
    final scheduledDate = tz.TZDateTime(
      tz.local,
      eventDate.year,
      eventDate.month,
      eventDate.day,
      8, // 8:00 AM
    );

    // No programar si ya pasó ese momento
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    const darwinDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Cancela una notificación programada (útil si se cancela un ticket).
  Future<void> cancelNotification(int notificationId) async {
    await _plugin.cancel(notificationId);
  }
}
