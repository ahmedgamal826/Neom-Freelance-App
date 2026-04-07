import 'package:flutter/material.dart';
import 'package:neon/features/notifications/alarm%20code/utils/alarm_provider.dart';
import 'package:neon/features/notifications/alarm%20code/utils/notification_helper.dart';
import 'package:neon/features/notifications/alarm%20code/views/add_alarm.dart';
import 'package:neon/features/notifications/alarm%20code/widgets/show_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../widgets/alarm_card_shimmer.dart';

class AlarmPage extends StatefulWidget {
  final bool isDarkMode;
  final void Function()? onToggleDarkMode;

  const AlarmPage({Key? key, this.isDarkMode = false, this.onToggleDarkMode})
      : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> with TickerProviderStateMixin {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AnimationController _addButtonController;
  late AnimationController _cardController;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _initializeAnimations();
    // Start card animation when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cardController.forward();
      _fadeController.forward();
      _slideController.forward();
    });
  }

  void _initializeAnimations() {
    _addButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _addButtonController.dispose();
    _cardController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: androidInitSettings);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        await NotificationHelper.handleNotificationAction(details);
      },
    );
  }

  Future<void> _scheduleNotification(
      DateTime alarmTime, String title, String body) async {
    final tzDateTime = tz.TZDateTime.from(alarmTime, tz.local);

    if (tzDateTime.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      'alarm_app_channel_v2', // <-- اسم قناة جديد لمزامنة الصوت
      'Alarm Notifications',
      channelDescription: 'Channel for alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      sound: RawResourceAndroidNotificationSound(
          'sound'), // يمكنك تعديلها لتمرير الصوت المناسب
      largeIcon: DrawableResourceAndroidBitmap(
          '@mipmap/ic_launcher'), // أيقونة التطبيق
      styleInformation: BigTextStyleInformation(''),
      actions: [
        AndroidNotificationAction(
          'SNOOZE',
          'غفوة (Snooze)',
          showsUserInterface: true,
          allowGeneratedReplies: false,
        ),
        AndroidNotificationAction(
          'STOP_ALARM',
          'إيقاف المنبه (Stop Alarm)',
          showsUserInterface: true,
          allowGeneratedReplies: false,
        ),
      ],
    );

    final iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'sound.mp3', // صوت مخصص iOS
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      alarmTime.millisecondsSinceEpoch.hashCode,
      title,
      body,
      tzDateTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> _updateAlarmTime(
      BuildContext context, AlarmProvider alarmProvider, int index) async {
    DateTime currentTime =
        DateTime.parse(alarmProvider.alarmList[index].dateTime);
    // Ensure currentTime is not before now
    if (currentTime.isBefore(DateTime.now())) {
      currentTime = DateTime.now().add(const Duration(minutes: 1));
    }

    DateTime? newDateTime = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: widget.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              "Edit Alarm",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: currentTime,
                  minimumDate: DateTime.now(),
                  use24hFormat: false,
                  backgroundColor:
                      widget.isDarkMode ? Colors.black : Colors.white,
                  onDateTimeChanged: (DateTime dateTime) {
                    currentTime = dateTime;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(currentTime),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (newDateTime != null) {
      if (newDateTime.isBefore(DateTime.now())) {
        if (context.mounted) {
          customShowSnackBar(
            context: context,
            content: 'Please select a future time',
            backgroundColor: Colors.red,
          );
        }
        return;
      }

      alarmProvider.alarmList[index].dateTime = newDateTime.toIso8601String();
      alarmProvider.notifyListeners();
      await alarmProvider.setData();

      await _scheduleNotification(
        newDateTime,
        'Alarm',
        'إشعار من مشروع نيوم',
      );

      Duration remainingTime = newDateTime.difference(DateTime.now());
      if (context.mounted) {
        customShowSnackBar(
          context: context,
          content:
              'Alarm set for ${remainingTime.inHours}h ${remainingTime.inMinutes % 60}m from now',
          backgroundColor: Colors.blue,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlarmProvider>(
      builder: (context, alarmProvider, child) {
        return Scaffold(
          backgroundColor:
              widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          body: Container(
            color: widget.isDarkMode ? null : Colors.white,
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                Expanded(
                  child: alarmProvider.isLoading
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: 5, // Show 5 shimmer cards
                          itemBuilder: (context, index) {
                            return AlarmCardShimmer(
                                isDarkMode: widget.isDarkMode);
                          },
                        )
                      : alarmProvider.alarmList.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.alarm_off,
                                    size: 80,
                                    color: widget.isDarkMode
                                        ? Colors.white54
                                        : Colors.black54,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No alarms set',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: widget.isDarkMode
                                          ? Colors.white54
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: alarmProvider.alarmList.length,
                              itemBuilder: (context, index) {
                                final alarm = alarmProvider.alarmList[index];
                                final alarmTime =
                                    DateTime.parse(alarm.dateTime);
                                final now = DateTime.now();
                                final isToday = alarmTime.day == now.day &&
                                    alarmTime.month == now.month &&
                                    alarmTime.year == now.year;
                                final isTomorrow =
                                    alarmTime.day == now.day + 1 &&
                                        alarmTime.month == now.month &&
                                        alarmTime.year == now.year;

                                String dateText = '';
                                if (isToday) {
                                  dateText = 'يوميًا';
                                } else if (isTomorrow) {
                                  dateText = 'غدًا';
                                } else {
                                  dateText =
                                      DateFormat('MMM d').format(alarmTime);
                                }

                                // Create a unique animation for each card
                                final animation = CurvedAnimation(
                                  parent: _cardController,
                                  curve: Interval(
                                    index * 0.1,
                                    1.0,
                                    curve: Curves.easeOut,
                                  ),
                                );

                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(1, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: Dismissible(
                                    key: Key(alarm.dateTime),
                                    background: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade400,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 20),
                                      child: const Icon(Icons.delete,
                                          color: Colors.white),
                                    ),
                                    direction: DismissDirection.endToStart,
                                    confirmDismiss: (direction) async {
                                      final isDark = widget.isDarkMode;
                                      bool? confirm = await showDialog<bool>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            title: Row(
                                              children: [
                                                Icon(
                                                    Icons.warning_amber_rounded,
                                                    color: Colors.red[400]),
                                                const SizedBox(width: 8),
                                                const Text('Delete Alarm?'),
                                              ],
                                            ),
                                            content: const Text(
                                              'Are you sure you want to delete this alarm?',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                child: const Text('Delete',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      return confirm == true;
                                    },
                                    onDismissed: (direction) async {
                                      await alarmProvider.deleteAlarm(index);
                                      if (context.mounted) {
                                        customShowSnackBar(
                                          context: context,
                                          content: 'Alarm deleted',
                                          backgroundColor: Colors.red,
                                        );
                                      }
                                    },
                                    child: Card(
                                      elevation: 4,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      color: widget.isDarkMode
                                          ? Colors.grey[850]
                                          : Colors.white,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  Switch(
                                                    value: alarm.isActive,
                                                    onChanged: (value) {
                                                      alarmProvider
                                                          .toggleAlarm(index);
                                                    },
                                                    activeColor: Colors.blue,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        DateFormat('hh:mm a')
                                                            .format(alarmTime),
                                                        style: TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: widget
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                      if (alarm.repeat !=
                                                              null &&
                                                          alarm.repeat!
                                                              .isNotEmpty)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 6),
                                                          child: Text(
                                                            'التكرار: ${alarm.repeat == 'daily' ? 'يومي' : 'مرة واحدة'}',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: widget
                                                                      .isDarkMode
                                                                  ? Colors
                                                                      .grey[400]
                                                                  : Colors.grey[
                                                                      600],
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                alarm.label ??
                                                                    'Alarm',
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: widget
                                                                          .isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 4),
                                                              Text(
                                                                dateText,
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: widget
                                                                          .isDarkMode
                                                                      ? Colors.grey[
                                                                          400]
                                                                      : Colors.grey[
                                                                          600],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 12),
                                                        Icon(
                                                          Icons.alarm,
                                                          size: 24,
                                                          color: alarm.isActive
                                                              ? Colors.blue
                                                              : widget
                                                                      .isDarkMode
                                                                  ? Colors.grey
                                                                  : Colors.grey[
                                                                      400],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
          // أضف زر الإضافة كـ FloatingActionButton
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF2196F3),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAlarm(isDarkMode: widget.isDarkMode),
                ),
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Icon(
              Icons.add,
              color: widget.isDarkMode ? Colors.white : Colors.white,
              size: 28,
            ),
          ),
        );
      },
    );
  }
}
