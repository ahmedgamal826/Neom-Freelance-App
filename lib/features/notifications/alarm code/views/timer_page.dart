import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:neon/features/notifications/alarm%20code/widgets/animation_title.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class TimerPage extends StatefulWidget {
  final bool isDarkMode;
  final void Function()? onToggleDarkMode;

  const TimerPage({super.key, required this.isDarkMode, this.onToggleDarkMode});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  Timer? timer;
  bool isRunning = false;
  int initialTotalSeconds = 0; // <-- أضف هذا المتغير
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _animation;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Controllers for input fields
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  static const String _timerEndKey = 'timer_end_time';
  static const String _timerNotificationIdKey = 'timer_notification_id';
  static const int _ongoingNotificationId = 999999;
  static const String _timerEndNotificationIdKey = 'timer_end_notification_id';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeNotifications();
    tz.initializeTimeZones();
    _restoreTimerState();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  Future<void> _restoreTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    final endTimeStr = prefs.getString(_timerEndKey);
    final initialTotal = prefs.getInt('timer_initial_total_seconds');
    if (endTimeStr != null) {
      final endTime = DateTime.parse(endTimeStr);
      final now = DateTime.now();
      if (now.isBefore(endTime)) {
        final remaining = endTime.difference(now);
        setState(() {
          hours = remaining.inHours;
          minutes = remaining.inMinutes % 60;
          seconds = remaining.inSeconds % 60;
          isRunning = true;
          initialTotalSeconds =
              initialTotal ?? (remaining.inSeconds); // fallback
        });
        _startTimerWithEndTime(endTime);
      } else {
        setState(() {
          hours = 0;
          minutes = 0;
          seconds = 0;
          isRunning = false;
          initialTotalSeconds = 0;
        });
        await prefs.remove(_timerEndKey);
        await prefs.remove('timer_initial_total_seconds');
      }
    }
  }

  Future<void> _scheduleTimerNotification(
      DateTime endTime, int notificationId) async {
    try {
      final totalSeconds = endTime.difference(DateTime.now()).inSeconds;
      final duration = Duration(seconds: totalSeconds);
      String formattedDuration = _formatDuration(duration);
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        'Timer Finished',
        'Your timer for $formattedDuration has finished.',
        tz.TZDateTime.from(endTime, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'alarm_app_channel_v2', // <-- اسم قناة جديد لمزامنة الصوت
            'Timer Notifications',
            channelDescription: 'Notifications for timer completion',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            playSound: true,
            icon: '@mipmap/ic_launcher',
            sound: RawResourceAndroidNotificationSound(
                'sound'), // يمكنك تعديلها لتمرير الصوت المناسب
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            sound: 'sound.mp3', // <-- صوت مخصص iOS
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint('Error scheduling timer notification: $e');
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  Future<void> _cancelTimerNotification(int notificationId) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(notificationId);
    } catch (e) {
      debugPrint('Error canceling timer notification: $e');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        debugPrint('Notification clicked');
      },
    );

    // Create notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'timer_channel',
      'Timer Notifications',
      description: 'Notifications for timer completion',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'timer_channel',
      'Timer Notifications',
      channelDescription: 'Notifications for timer completion',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  Future<void> _showOngoingTimerNotification(
      int secondsLeft, int notificationId) async {
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      'Timer Running',
      'Time left:  ${_formatDuration(Duration(seconds: secondsLeft))}',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'timer_channel',
          'Timer Notifications',
          channelDescription: 'Timer is running',
          importance: Importance.max,
          priority: Priority.high,
          ongoing: true,
          onlyAlertOnce: true,
          showWhen: false,
        ),
      ),
    );
  }

  void _startTimerWithEndTime(DateTime endTime) async {
    timer?.cancel();
    final prefs = await SharedPreferences.getInstance();
    timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      final now = DateTime.now();
      if (now.isBefore(endTime)) {
        final remaining = endTime.difference(now);
        setState(() {
          hours = remaining.inHours;
          minutes = remaining.inMinutes % 60;
          seconds = remaining.inSeconds % 60;
        });
        await _showOngoingTimerNotification(
            remaining.inSeconds, _ongoingNotificationId);
      } else {
        t.cancel();
        setState(() {
          hours = 0;
          minutes = 0;
          seconds = 0;
          isRunning = false;
        });
        // ألغِ إشعار التايمر الدائم فور انتهاء المؤقت
        await flutterLocalNotificationsPlugin.cancel(_ongoingNotificationId);
        // لا تلغِ إشعار الانتهاء المجدول هنا
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_timerEndKey);
      }
    });
    // عند بدء المؤقت أظهر الإشعار فوراً
    final now = DateTime.now();
    final remaining = endTime.difference(now);
    await _showOngoingTimerNotification(
        remaining.inSeconds, _ongoingNotificationId);
  }

  void startTimer() async {
    if (hours == 0 && minutes == 0 && seconds == 0) return;
    setState(() {
      isRunning = true;
      initialTotalSeconds =
          (hours * 3600) + (minutes * 60) + seconds; // <-- هنا
    });
    final totalSeconds = initialTotalSeconds;
    final endTime = DateTime.now().add(Duration(seconds: totalSeconds));
    final endNotificationId =
        1000000 + endTime.millisecondsSinceEpoch.remainder(1000000);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_timerEndKey, endTime.toIso8601String());
    await prefs.setInt(_timerNotificationIdKey, _ongoingNotificationId);
    await prefs.setInt(_timerEndNotificationIdKey, endNotificationId);
    await prefs.setInt(
        'timer_initial_total_seconds', initialTotalSeconds); // <-- حفظ القيمة
    await _scheduleTimerNotification(endTime, endNotificationId);
    _startTimerWithEndTime(endTime);
  }

  void stopTimer() async {
    setState(() {
      timer?.cancel();
      isRunning = false;
    });
    final prefs = await SharedPreferences.getInstance();
    final endNotificationId = prefs.getInt(_timerEndNotificationIdKey);
    await flutterLocalNotificationsPlugin.cancel(_ongoingNotificationId);
    if (endNotificationId != null) {
      await _cancelTimerNotification(endNotificationId);
      await prefs.remove(_timerEndNotificationIdKey);
    }
    await prefs.remove(_timerNotificationIdKey);
    await prefs.remove(_timerEndKey);
  }

  void resetTimer() async {
    setState(() {
      timer?.cancel();
      hours = 0;
      minutes = 0;
      seconds = 0;
      isRunning = false;
      initialTotalSeconds = 0; // <-- إعادة التعيين
    });
    _hoursController.clear();
    _minutesController.clear();
    _secondsController.clear();
    final prefs = await SharedPreferences.getInstance();
    final endNotificationId = prefs.getInt(_timerEndNotificationIdKey);
    await flutterLocalNotificationsPlugin.cancel(_ongoingNotificationId);
    if (endNotificationId != null) {
      await _cancelTimerNotification(endNotificationId);
      await prefs.remove(_timerEndNotificationIdKey);
    }
    await prefs.remove(_timerNotificationIdKey);
    await prefs.remove(_timerEndKey);
    await prefs.remove('timer_initial_total_seconds'); // <-- إزالة القيمة
  }

  void setTimer() {
    int hours = int.tryParse(_hoursController.text) ?? 0;
    int minutes = int.tryParse(_minutesController.text) ?? 0;
    int seconds = int.tryParse(_secondsController.text) ?? 0;

    setState(() {
      this.hours = hours;
      this.minutes = minutes;
      this.seconds = seconds;
    });
  }

  String formatTime(int seconds) {
    int hours = (seconds ~/ 3600);
    int minutes = (seconds ~/ 60) % 60;
    int remainingSeconds = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  void _showTimePicker(
      {required int max,
      required int initial,
      required String label,
      required Function(int) onSelected}) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          widget.isDarkMode ? const Color(0xFF23242B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Select $label',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController:
                      FixedExtentScrollController(initialItem: initial),
                  itemExtent: 44,
                  backgroundColor: Colors.transparent,
                  onSelectedItemChanged: onSelected,
                  children: List.generate(
                      max + 1,
                      (i) => Center(
                            child: Text(
                              i.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: 24,
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimePickerBox(int value, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: widget.isDarkMode ? Colors.white10 : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isDarkMode ? Colors.white24 : Colors.blueAccent,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value.toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: widget.isDarkMode ? Colors.white54 : Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInputField(
      TextEditingController controller, String hint, bool isDarkMode) {
    return SizedBox(
      width: 48,
      child: TextField(
        cursorColor: isDarkMode ? Colors.white : Colors.black,
        controller: controller,
        enabled: !isRunning,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: widget.isDarkMode ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: widget.isDarkMode ? Colors.white54 : Colors.black38,
            fontSize: 18,
          ),
          filled: true,
          fillColor: widget.isDarkMode ? Colors.white10 : Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: widget.isDarkMode ? Colors.white24 : Colors.blueAccent,
              width: 1.2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: widget.isDarkMode ? Colors.white24 : Colors.blueAccent,
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
        ),
        onChanged: (_) => setTimer(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalSeconds = (hours * 3600) + (minutes * 60) + seconds;
    final progress = initialTotalSeconds > 0
        ? totalSeconds / initialTotalSeconds
        : 1.0; // <-- استخدم المتغير الجديد
    return Scaffold(
      backgroundColor:
          widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      body: Container(
        color: widget.isDarkMode ? null : Colors.white,
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AnimationTitle(
                    animationTitle: 'Timer',
                    fadeController: _fadeController,
                    slideController: _slideController,
                    isDarkMode: widget.isDarkMode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // --- الدائرة العلوية ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                width: 260,
                height: 260,
                child: TweenAnimationBuilder<double>(
                  tween:
                      Tween<double>(begin: 1.0, end: progress.clamp(0.0, 1.0)),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return CustomPaint(
                      painter: TimerCircleProgressPainter(
                        progress: value,
                        isDarkMode: widget.isDarkMode,
                        isRunning: isRunning,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${hours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Hours : Minutes : Seconds',
                              style: TextStyle(
                                fontSize: 14,
                                color: widget.isDarkMode
                                    ? Colors.white60
                                    : Colors.black54,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (initialTotalSeconds > 0)
                              Text(
                                'Total: '
                                '${(initialTotalSeconds ~/ 3600).toString().padLeft(2, '0')}:'
                                '${((initialTotalSeconds % 3600) ~/ 60).toString().padLeft(2, '0')}:'
                                '${(initialTotalSeconds % 60).toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: widget.isDarkMode
                                      ? Colors.blue[200]
                                      : Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // --- نهاية الدائرة ---
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimePickerBox(hours, 'HH', () {
                  _showTimePicker(
                    max: 23,
                    initial: hours,
                    label: 'Hours',
                    onSelected: (val) {
                      setState(() => hours = val);
                    },
                  );
                }),
                const SizedBox(width: 12),
                _buildTimePickerBox(minutes, 'MM', () {
                  _showTimePicker(
                    max: 59,
                    initial: minutes,
                    label: 'Minutes',
                    onSelected: (val) {
                      setState(() => minutes = val);
                    },
                  );
                }),
                const SizedBox(width: 12),
                _buildTimePickerBox(seconds, 'SS', () {
                  _showTimePicker(
                    max: 59,
                    initial: seconds,
                    label: 'Seconds',
                    onSelected: (val) {
                      setState(() => seconds = val);
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'start',
                  backgroundColor:
                      isRunning ? Colors.redAccent : Color(0xFF2196F3),
                  onPressed: isRunning ? stopTimer : startTimer,
                  child: Icon(
                    isRunning ? Icons.stop : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 24),
                FloatingActionButton(
                  heroTag: 'reset',
                  backgroundColor:
                      widget.isDarkMode ? Colors.grey[800] : Colors.grey[300],
                  onPressed: resetTimer,
                  child: Icon(
                    Icons.refresh,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                    size: 28,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- عداد الدائرة للتايمر (نفس شكل stopwatch) ---
class TimerCircleProgressPainter extends CustomPainter {
  final double progress; // 1.0 = full, 0.0 = empty
  final bool isDarkMode;
  final bool isRunning;
  TimerCircleProgressPainter(
      {required this.progress,
      required this.isDarkMode,
      required this.isRunning});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw background track
    final trackPaint = Paint()
      ..color = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    canvas.drawCircle(center, radius - 5, trackPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = isRunning ? Colors.blue : Colors.blue.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 5),
      -90 * (3.14159 / 180), // Start from top
      progress * 2 * 3.14159, // Full circle is 2*pi radians
      false,
      progressPaint,
    );

    // Draw outer glow
    final glowPaint = Paint()
      ..color = isRunning
          ? Colors.blue.withOpacity(0.2)
          : Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius, glowPaint);
  }

  @override
  bool shouldRepaint(TimerCircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isRunning != isRunning ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}
