import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:neon/features/notifications/alarm%20code/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _countdown = 15;
  Timer? _timer;
  bool _isRecurringEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadRecurringState();
    _loadCountdownState();
  }

  Future<void> _loadRecurringState() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('recurring_notification_enabled') ?? false;
    if (!mounted) return;
    setState(() {
      _isRecurringEnabled = enabled;
    });
    if (enabled) {
      _scheduleRecurringNotifications();
    }
  }

  Future<void> _saveRecurringState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('recurring_notification_enabled', value);
  }

  Future<void> _loadCountdownState() async {
    final prefs = await SharedPreferences.getInstance();
    final int? lastCountdown = prefs.getInt('notification_countdown');
    final int? lastTimestamp = prefs.getInt('notification_countdown_timestamp');
    if (lastCountdown != null && lastTimestamp != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final elapsed = ((now - lastTimestamp) / 1000).round();
      final remaining = lastCountdown - elapsed;
      if (remaining > 0) {
        if (!mounted) return;
        setState(() {
          _countdown = remaining;
        });
        _resumeCountdown();
      } else {
        await _clearCountdownState();
      }
    }
  }

  Future<void> _saveCountdownState(int countdown) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notification_countdown', countdown);
    await prefs.setInt('notification_countdown_timestamp',
        DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> _clearCountdownState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notification_countdown');
    await prefs.remove('notification_countdown_timestamp');
  }

  void _resumeCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
        await _saveCountdownState(_countdown);
      } else {
        timer.cancel();
        await _clearCountdownState();
      }
    });
  }

  void _startCountdown() {
    if (!mounted) return;
    setState(() {
      _countdown = 15;
    });
    _saveCountdownState(15);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
        await _saveCountdownState(_countdown);
      } else {
        timer.cancel();
        await _clearCountdownState();
      }
    });
  }

  Future<void> _scheduleNotification() async {
    await NotificationHelper.scheduleNotification(
      id: 0,
      title: 'Scheduled Notification',
      body: 'This is a test notification',
      scheduledDate: DateTime.now().add(const Duration(seconds: 15)),
    );
  }

  void startCountdownAndScheduleNotification() {
    _startCountdown();
    _scheduleNotification();
  }

  Future<void> _scheduleRecurringNotifications() async {
    final now = DateTime.now();
    for (int i = 1; i <= 12; i++) {
      await NotificationHelper.scheduleNotification(
        id: 1000 + i,
        title: 'Reminder',
        body: 'This is your 5-minute recurring notification',
        scheduledDate: now.add(Duration(minutes: 5 * i)),
      );
    }
  }

  Future<void> _toggleRecurring(bool value) async {
    if (!mounted) return;
    setState(() {
      _isRecurringEnabled = value;
    });
    await _saveRecurringState(value);
    if (value) {
      await _scheduleRecurringNotifications();
    } else {
      for (int i = 1; i <= 12; i++) {
        await NotificationHelper.cancelNotification(1000 + i);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: isDark ? const Color(0xFF232526) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: isDark ? const Color(0xFF232526) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(Icons.notifications_active,
                        size: 48,
                        color: isDark ? Colors.blue[200] : Colors.blue),
                    const SizedBox(height: 12),
                    Text(
                      'Schedule Notification',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You can schedule a notification after 15 seconds or enable a recurring notification every 5 minutes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Recurring every 5 min',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 12),
                        CupertinoSwitch(
                          value: _isRecurringEnabled,
                          onChanged: _toggleRecurring,
                          activeColor: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Notification will be sent in:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              '$_countdown seconds',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _countdown == 15
                  ? startCountdownAndScheduleNotification
                  : null,
              icon: const Icon(Icons.schedule),
              label: const Text('Schedule Notification (15s)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}