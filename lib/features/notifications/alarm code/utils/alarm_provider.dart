import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:neon/features/notifications/alarm%20code/models/alarm_model.dart';
import 'package:neon/features/notifications/alarm%20code/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmProvider extends ChangeNotifier {
  SharedPreferences? _preferences;
  List<AlarmModel> _alarmList = [];
  bool _isLoading = true;

  List<AlarmModel> get alarmList => _alarmList;
  bool get isLoading => _isLoading;

  AlarmProvider() {
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    try {
      debugPrint('Initializing SharedPreferences...');
      _preferences = await SharedPreferences.getInstance();
      await getData();
      debugPrint('SharedPreferences initialized successfully');
      debugPrint('Number of alarms loaded: ${_alarmList.length}');
    } catch (e) {
      debugPrint('Error initializing SharedPreferences: $e');
    }
  }

  Future<void> setAlarm({
    required String dateTime,
    String? label,
    String? alarmDate,
    String? repeat,
    required int id,
    int? milliseconds,
    String? ringtone,
    int? snoozeDuration,
  }) async {
    try {
      debugPrint('Setting new alarm...');
      if (_preferences == null) {
        debugPrint('SharedPreferences not initialized, initializing now...');
        _preferences = await SharedPreferences.getInstance();
      }

      final alarm = AlarmModel(
        label: label,
        dateTime: dateTime,
        alarmDate: alarmDate,
        repeat: repeat,
        id: id,
        milliseconds: milliseconds,
        ringtone: ringtone,
        snoozeDuration: snoozeDuration,
      );

      _alarmList.add(alarm);
      await setData();
      debugPrint(
          'New alarm added successfully. Total alarms:  {_alarmList.length}');

      // Schedule the notification
      await NotificationHelper.scheduleNotification(
        id: id,
        title: label ?? 'Alarm',
        body: 'Time to wake up!',
        scheduledDate: DateTime.parse(dateTime),
        ringtone: ringtone,
        snoozeDuration: snoozeDuration,
        repeatDaily: repeat == 'daily',
      );

      notifyListeners();
    } catch (e) {
      debugPrint('Error setting alarm: $e');
    }
  }

  Future<void> toggleAlarm(int index) async {
    if (index >= 0 && index < _alarmList.length) {
      _alarmList[index].isActive = !_alarmList[index].isActive;

      if (_alarmList[index].isActive) {
        // Reschedule the notification
        await NotificationHelper.scheduleNotification(
          id: _alarmList[index].id,
          title: _alarmList[index].label ?? 'Alarm',
          body: 'Time to wake up!',
          scheduledDate: DateTime.parse(_alarmList[index].dateTime),
          ringtone: _alarmList[index].ringtone,
          snoozeDuration: _alarmList[index].snoozeDuration,
          repeatDaily: _alarmList[index].repeat == 'daily',
        );
      } else {
        // Cancel the notification
        await NotificationHelper.cancelNotification(_alarmList[index].id);
      }

      await setData();
      notifyListeners();
    }
  }

  Future<void> deleteAlarm(int index) async {
    if (index >= 0 && index < _alarmList.length) {
      // Cancel the notification first
      await NotificationHelper.cancelNotification(_alarmList[index].id);

      // Remove the alarm from the list
      _alarmList.removeAt(index);
      await setData();
      notifyListeners();
    }
  }

  Future<void> getData() async {
    try {
      debugPrint('Getting alarm data from SharedPreferences...');
      if (_preferences == null) {
        debugPrint('SharedPreferences not initialized, initializing now...');
        _preferences = await SharedPreferences.getInstance();
      }

      final String? alarmsJson = _preferences?.getString('alarms');
      debugPrint('Alarms JSON from SharedPreferences: $alarmsJson');

      if (alarmsJson != null) {
        final List<dynamic> alarmsList = json.decode(alarmsJson);
        _alarmList =
            alarmsList.map((json) => AlarmModel.fromJson(json)).toList();
        debugPrint(
            'Alarms loaded successfully. Number of alarms: ${_alarmList.length}');
      } else {
        debugPrint('No alarms found in SharedPreferences');
        _alarmList = [];
      }
    } catch (e) {
      debugPrint('Error getting alarm data: $e');
      _alarmList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setData() async {
    try {
      debugPrint('Saving alarm data to SharedPreferences...');
      if (_preferences == null) {
        debugPrint('SharedPreferences not initialized, initializing now...');
        _preferences = await SharedPreferences.getInstance();
      }

      final String alarmsJson =
          json.encode(_alarmList.map((alarm) => alarm.toJson()).toList());
      await _preferences?.setString('alarms', alarmsJson);
      debugPrint('Alarm data saved successfully');
    } catch (e) {
      debugPrint('Error saving alarm data: $e');
    }
  }

  Future<void> updateAlarm(
    int index, {
    String? dateTime,
    String? label,
    String? alarmDate,
    String? repeat,
    int? milliseconds,
    String? ringtone,
    int? snoozeDuration,
  }) async {
    if (index >= 0 && index < _alarmList.length) {
      final alarm = _alarmList[index];

      // Cancel the old notification
      await NotificationHelper.cancelNotification(alarm.id);

      // Update the alarm properties
      if (dateTime != null) alarm.dateTime = dateTime;
      if (label != null) alarm.label = label;
      if (alarmDate != null) alarm.alarmDate = alarmDate;
      if (repeat != null) alarm.repeat = repeat;
      if (milliseconds != null) alarm.milliseconds = milliseconds;
      if (ringtone != null) alarm.ringtone = ringtone;
      if (snoozeDuration != null) alarm.snoozeDuration = snoozeDuration;

      // Schedule the new notification if the alarm is active
      if (alarm.isActive) {
        await NotificationHelper.scheduleNotification(
          id: alarm.id,
          title: alarm.label ?? 'Alarm',
          body: 'Time to wake up!',
          scheduledDate: DateTime.parse(alarm.dateTime),
          ringtone: alarm.ringtone,
          snoozeDuration: alarm.snoozeDuration,
          repeatDaily: alarm.repeat == 'daily',
        );
      }

      await setData();
      notifyListeners();
    }
  }
}
