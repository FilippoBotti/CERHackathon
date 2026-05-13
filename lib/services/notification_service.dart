import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int testNotificationId = 999;

  static const String _channelId = 'appliance_reminders';
  static const String _channelName = 'Promemoria elettrodomestici';
  static const String _channelDescription =
      'Notifiche per usare gli elettrodomestici nelle ore migliori';

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tzData.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Rome'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await _plugin.initialize(settings: settings);

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();

    

    _initialized = true;
  }

  Future<void> scheduleApplianceReminder({
    required DateTime scheduledTime,
    required DateTime reminderDate,
    required String title,
    required String body,
  }) async {
    await init();

    if (scheduledTime.isBefore(DateTime.now())) {
      throw Exception('Orario già passato.');
    }

    final notificationId = _startReminderIdForDate(reminderDate);

    print(  'Programmo notifica $notificationId per ${scheduledTime.toIso8601String()}');
    await _scheduleWithFallback(
      id: notificationId,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
    );
  }

  Future<void> scheduleRangeEndNotification({
    required DateTime endTime,
    required DateTime reminderDate,
    required String title,
    required String body,
  }) async {
    await init();

    if (endTime.isBefore(DateTime.now())) {
      return;
    }

    final notificationId = _endReminderIdForDate(reminderDate);

    await _scheduleWithFallback(
      id: notificationId,
      title: title,
      body: body,
      scheduledTime: endTime,
    );
  }

  Future<void> cancelApplianceReminderForDate(DateTime date) async {
    await init();

    await _plugin.cancel(id: _startReminderIdForDate(date));
    await _plugin.cancel(id: _endReminderIdForDate(date));
  }

  Future<void> showTestNotification({
    required String title,
    required String body,
  }) async {
    await init();

    await _plugin.show(
      id: testNotificationId,
      title: title,
      body: body,
      notificationDetails: _notificationDetails(),
    );
  }

  Future<void> cancelTestNotification() async {
    await init();

    await _plugin.cancel(id: testNotificationId);
  }

  Future<List<PendingNotificationRequest>> pendingNotifications() async {
    await init();

    return _plugin.pendingNotificationRequests();
  }

  Future<void> _scheduleWithFallback({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      print('Scheduled exact notification $id for ${scheduledTime.toIso8601String()}');
       

      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
        notificationDetails: _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
        notificationDetails: _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  int _startReminderIdForDate(DateTime date) {
    return int.parse('${_dateNumber(date)}1');
  }

  int _endReminderIdForDate(DateTime date) {
    return int.parse('${_dateNumber(date)}2');
  }

  String _dateNumber(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year$month$day';
  }
}