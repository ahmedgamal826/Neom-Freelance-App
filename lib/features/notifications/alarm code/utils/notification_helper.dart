import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Added for SharedPreferences

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
        body: 'Time to wake up!',
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
}
