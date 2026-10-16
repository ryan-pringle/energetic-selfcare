import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:energetic_selfcare/models/settings.dart';

/// Twice-daily local notifications.
///
/// On the phone this schedules morning and evening reminders. The browser
/// cannot hold a repeating local notification, so the web build only keeps
/// the chosen times and the screen explains that.
class PracticeReminders {
  PracticeReminders._();

  static final PracticeReminders instance = PracticeReminders._();

  static const morningId = 701;
  static const eveningId = 702;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool ready = false;

  Future<void> init() async {
    if (kIsWeb) {
      return;
    }
    try {
      tz_data.initializeTimeZones();
      await _useLocalZone();
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwin = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: android,
          iOS: darwin,
          macOS: darwin,
        ),
      );
      ready = true;
    } on Object {
      ready = false;
    }
  }

  Future<void> _useLocalZone() async {
    String? identifier;
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      identifier = info.identifier;
    } on Object {
      identifier = null;
    }
    if (identifier != null) {
      try {
        tz.setLocalLocation(tz.getLocation(identifier));
        return;
      } on Object {
        // Fall through to an offset match.
      }
    }
    final offset = DateTime.now().timeZoneOffset;
    for (final location in tz.timeZoneDatabase.locations.values) {
      if (tz.TZDateTime.now(location).timeZoneOffset == offset) {
        tz.setLocalLocation(location);
        return;
      }
    }
    tz.setLocalLocation(tz.UTC);
  }

  /// Asks the phone for notification permission. Web always returns false.
  Future<bool> ensurePermission() async {
    if (kIsWeb || !ready) {
      return false;
    }
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final ios = _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        final granted = await ios?.requestPermissions(
          alert: true,
          badge: false,
          sound: true,
        );
        return granted ?? false;
      }
      if (defaultTargetPlatform == TargetPlatform.android) {
        final android = _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        final granted = await android?.requestNotificationsPermission();
        final exact = await android?.requestExactAlarmsPermission();
        _preferExact = exact != false;
        // Older Android returns null because the permission prompt does not exist.
        return granted ?? true;
      }
    } on Object {
      return false;
    }
    return false;
  }

  bool _preferExact = true;

  Future<void> apply(ReminderSettings settings) async {
    if (kIsWeb || !ready) {
      return;
    }
    try {
      if (settings.morningEnabled) {
        await _schedule(
          id: morningId,
          minutes: settings.morningMinutes,
          title: 'Morning practice',
          body: 'A quiet moment to tend your energy field.',
        );
      } else {
        await _plugin.cancel(id: morningId);
      }
      if (settings.eveningEnabled) {
        await _schedule(
          id: eveningId,
          minutes: settings.eveningMinutes,
          title: 'Evening practice',
          body: 'Settle the field before you rest.',
        );
      } else {
        await _plugin.cancel(id: eveningId);
      }
    } on Object {
      // The saved times remain. The phone can try again next launch.
    }
  }

  Future<void> _schedule({
    required int id,
    required int minutes,
    required String title,
    required String body,
  }) async {
    final when = _nextInstance(minutes);
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'energetic_selfcare_reminders',
        'Practice reminders',
        channelDescription:
            'Morning and evening reminders for energetic selfcare.',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: true,
      ),
    );
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: when,
      notificationDetails: details,
      androidScheduleMode: _preferExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstance(int minutes) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      minutes ~/ 60,
      minutes % 60,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
