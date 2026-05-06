import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Added for SharedPreferences
import 'dart:math';
import 'package:neon/features/notifications/data/neom_messages.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        handleNotificationAction(details);
      },
    );
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? ringtone,
    int? snoozeDuration,
    bool repeatDaily = false,
  }) async {
    try {
      // ربط أسماء النغمات بملفات الصوت:
      // Default    → sound.mp3
      // Ringtone 1 → sound2.mp3
      // Ringtone 2 → sound3.mp3
      // Ringtone 3 → sound4.mp3
      String androidSound = 'sound';
      String iosSound = 'sound.mp3';
      if (ringtone == 'Ringtone 1') {
        androidSound = 'sound2';
        iosSound = 'sound2.mp3';
      } else if (ringtone == 'Ringtone 2') {
        androidSound = 'sound3';
        iosSound = 'sound3.mp3';
      } else if (ringtone == 'Ringtone 3') {
        androidSound = 'sound4';
        iosSound = 'sound4.mp3';
      }
      final String channelId = 'alarm_channel_$androidSound';
      final String channelName = 'Alarm - ${ringtone ?? 'Default'}';
      final String channelDescription =
          'Channel for alarms with ${ringtone ?? 'Default'} ringtone';

      debugPrint(
          'جدولة إشعار: ringtone=$ringtone, androidSound=$androidSound, iosSound=$iosSound, channelId=$channelId');
      final androidDetails = AndroidNotificationDetails(
        channelId, // <-- استخدام Channel ID ديناميكي
        channelName, // <-- استخدام Channel Name ديناميكي
        channelDescription: channelDescription, // <-- استخدام وصف ديناميكي
        importance: Importance.max,
        priority: Priority.high,
        enableLights: true,
        enableVibration: true,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(androidSound),
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        actions: [
          const AndroidNotificationAction(
            'STOP_ALARM',
            'STOP ALARM',
            showsUserInterface: true,
            allowGeneratedReplies: false,
            cancelNotification: true,
          ),
          const AndroidNotificationAction(
            'SNOOZE',
            'SNOOZE',
            showsUserInterface: true,
            allowGeneratedReplies: false,
            cancelNotification: true,
          ),
        ],
      );

      final iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: iosSound,
        categoryIdentifier: 'alarm',
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );

      final scheduledTime = tz.TZDateTime.from(scheduledDate, tz.local);
      if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
        debugPrint('Scheduled time is in the past, skipping notification');
        return;
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: repeatDaily ? DateTimeComponents.time : null,
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
      // fallback logic
    }
  }

  static Future<void> handleNotificationAction(
      NotificationResponse details) async {
    final id = details.id;
    if (details.actionId == 'SNOOZE') {
      int snoozeDuration = 5;
      String? ringtone;
      final prefs = await SharedPreferences.getInstance();
      final alarmsJson = prefs.getString('alarms');
      if (alarmsJson != null) {
        final List<dynamic> alarmsList = json.decode(alarmsJson);
        final alarm = alarmsList.firstWhere(
          (a) => a['id'] == id,
          orElse: () => null,
        );
        if (alarm != null) {
          if (alarm['snoozeDuration'] != null) {
            snoozeDuration = alarm['snoozeDuration'] is int
                ? alarm['snoozeDuration']
                : int.tryParse(alarm['snoozeDuration'].toString()) ?? 5;
          }
          if (alarm['ringtone'] != null) {
            ringtone = alarm['ringtone'];
          }
        }
      }
      final now = DateTime.now();
      await scheduleNotification(
        id: id!,
        title: 'Alarm',
        body: 'إشعار من مشروع نيوم',
        scheduledDate: now.add(Duration(minutes: snoozeDuration)),
        snoozeDuration: snoozeDuration,
        ringtone: ringtone,
        repeatDaily: false, // Snooze should not repeat daily
      );
    } else if (details.actionId == 'STOP_ALARM') {
      await flutterLocalNotificationsPlugin.cancel(id!);
    }
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // ---------- NEOM daily auto messages ----------
  static int _dateKey(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

  // Deterministic per-day shuffle to keep same messages for the same date
  static List<String> _dailyMessages(DateTime date) {
    // Seeded shuffle keeps same 2 messages for the same calendar day.
    return _shuffleWithSeed(neomMessages, _dateKey(date));
  }

  // Pure function: returns a new shuffled copy using a seed
  static List<String> _shuffleWithSeed(List<String> input, int seed) {
    final list = List<String>.from(input);
    list.shuffle(Random(seed));
    return list;
  }

  // Schedule two notifications per day (10:00 and 17:00) for the next [daysAhead]
  // Each day picks two different messages from neomMessages in a deterministic order.
  static Future<void> scheduleNeomDailyAuto({int daysAhead = 60}) async {
    // Cancel any previously scheduled NEOM auto notifications for the range
    // We use id = 91000000 + yyyymmdd for 10:00 and 92000000 + yyyymmdd for 17:00
    final pending =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (final p in pending) {
      if (p.id >= 91000000 && p.id <= 92999999) {
        await flutterLocalNotificationsPlugin.cancel(p.id);
      }
    }

    final now = DateTime.now();
    for (int i = 0; i < daysAhead; i++) {
      final day = DateTime(now.year, now.month, now.day).add(Duration(days: i));
      final msgs = _dailyMessages(day);
      if (msgs.isEmpty) continue;
      final msg1 = msgs[0];
      final msg2 = msgs.length > 1 ? msgs[1] : msgs[0];

      final dateKey = _dateKey(day);
      // 10:00
      final tenAm = DateTime(day.year, day.month, day.day, 10, 0);
      await scheduleNotification(
        id: 91000000 + dateKey,
        title: msg1,
        body: 'إشعار من مشروع نيوم',
        scheduledDate: tenAm,
        repeatDaily: false,
      );
      // 17:00
      final fivePm = DateTime(day.year, day.month, day.day, 17, 0);
      await scheduleNotification(
        id: 92000000 + dateKey,
        title: msg2,
        body: 'إشعار من مشروع نيوم',
        scheduledDate: fivePm,
        repeatDaily: false,
      );
    }
  }

  // Schedules only when not already scheduled far enough to avoid blocking UI repeatedly
  // forceReschedule=true سيتخطّى التحقق ويعيد الجدولة حسب daysAhead
  static Future<void> ensureNeomDailyScheduled({
    int daysAhead = 60,
    bool forceReschedule = false,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? iso = prefs.getString('neom_scheduled_until');
      final DateTime? savedUntil = iso != null ? DateTime.tryParse(iso) : null;
      final DateTime target = DateTime.now().add(Duration(days: daysAhead));
      if (!forceReschedule &&
          savedUntil != null &&
          savedUntil.isAfter(target)) {
        // Already scheduled far enough
        return;
      }
      // الغِ أي إشعارات NEOM قديمة ضمن نطاقنا لتفادي الازدواج
      final pending =
          await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      for (final p in pending) {
        if (p.id >= 91000000 && p.id <= 92999999) {
          await flutterLocalNotificationsPlugin.cancel(p.id);
        }
      }
      await scheduleNeomDailyAuto(daysAhead: daysAhead);
      await prefs.setString('neom_scheduled_until', target.toIso8601String());
    } catch (e) {
      debugPrint('ensureNeomDailyScheduled error: $e');
    }
  }

  // Show notification immediately (for background callbacks)
  static Future<void> showNow({
    required String title,
    required String body,
  }) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        'neom_auto_now',
        'NEOM Auto Now',
        channelDescription: 'Immediate NEOM messages',
        importance: Importance.max,
        priority: Priority.high,
        enableLights: true,
        enableVibration: true,
        playSound: true,
      );
      final iOSDetails = const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      final details =
          NotificationDetails(android: androidDetails, iOS: iOSDetails);
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(1000000),
        title,
        body,
        details,
      );
    } catch (e) {
      debugPrint('showNow error: $e');
    }
  }

  // workmanager scheduling removed; using 30-day local scheduling instead
  // removed old android_alarm_manager_plus paths

  // Sync auto NEOM cards: show ONLY today's due items (<= now). Remove others.
  static Future<void> syncNeomAutoCardsForNow() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? alarmsJson = prefs.getString('alarms');
      List<dynamic> list = [];
      if (alarmsJson != null) {
        try {
          list = json.decode(alarmsJson);
        } catch (_) {}
      }
      // Keep only today's due auto items; drop all other auto items (future and past days)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      list = list.where((a) {
        if (a is! Map) return true;
        final int? id = a['id'];
        if (id == null) return true;
        if (id >= 91000000 && id <= 92999999) {
          final String? dt = a['dateTime'];
          if (dt == null) return false;
          final DateTime? d = DateTime.tryParse(dt);
          if (d == null) return false;
          final DateTime dd = DateTime(d.year, d.month, d.day);
          final bool isToday = dd == today;
          final bool isDue = d.isBefore(now) || d.isAtSameMomentAs(now);
          return isToday && isDue;
        }
        return true;
      }).toList();

      // Add today's due auto items if clock passed
      final msgs = _dailyMessages(today);
      if (msgs.isNotEmpty) {
        final tenAm = DateTime(today.year, today.month, today.day, 10, 0);
        if (now.isAfter(tenAm)) {
          final id = 91000000 + _dateKey(today);
          final exists = list.any((a) => a is Map && a['id'] == id);
          if (!exists) {
            list.add({
              'label': msgs[0],
              'dateTime': tenAm.toIso8601String(),
              'alarmDate': tenAm.toIso8601String(),
              'isActive': true,
              'isRead': false,
              'repeat': 'once',
              'id': id,
              'milliseconds': tenAm.millisecondsSinceEpoch,
              'ringtone': null,
              'snoozeDuration': 5,
            });
          }
        }
        if (msgs.length > 1) {
          final fivePm = DateTime(today.year, today.month, today.day, 17, 0);
          if (now.isAfter(fivePm)) {
            final id = 92000000 + _dateKey(today);
            final exists = list.any((a) => a is Map && a['id'] == id);
            if (!exists) {
              list.add({
                'label': msgs[1],
                'dateTime': fivePm.toIso8601String(),
                'alarmDate': fivePm.toIso8601String(),
                'isActive': true,
                'isRead': false,
                'repeat': 'once',
                'id': id,
                'milliseconds': fivePm.millisecondsSinceEpoch,
                'ringtone': null,
                'snoozeDuration': 5,
              });
            }
          }
        }
      }

      await prefs.setString('alarms', json.encode(list));
    } catch (e) {
      debugPrint('Failed to sync auto cards: $e');
    }
  }
}
