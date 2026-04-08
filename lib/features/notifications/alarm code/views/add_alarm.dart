import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neon/features/notifications/alarm%20code/utils/alarm_provider.dart';
import 'package:neon/features/notifications/alarm%20code/widgets/modern_input_container.dart';
import 'package:neon/features/notifications/alarm%20code/widgets/show_snack_bar.dart';
import 'package:neon/features/notifications/data/neom_messages.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

class AddAlarm extends StatefulWidget {
  final bool isDarkMode;

  const AddAlarm({Key? key, this.isDarkMode = false}) : super(key: key);

  @override
  _AddAlarmState createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> with TickerProviderStateMixin {
  late DateTime selectedDateTime;
  bool isDailyRepeat = false;
  String selectedRingtone = 'Default';
  int selectedSnooze = 5;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  bool isSaving = false;
  AudioPlayer? _audioPlayer;

  List<String> ringtones = [
    'Default',
    'Ringtone 1',
    'Ringtone 2',
    'Ringtone 3',
  ];

  String _ringtoneLabel(String value) {
    switch (value) {
      case 'Default':
        return 'الافتراضي';
      case 'Ringtone 1':
        return 'نغمة 1';
      case 'Ringtone 2':
        return 'نغمة 2';
      case 'Ringtone 3':
        return 'نغمة 3';
      default:
        return value;
    }
  }

  int _dayOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    return date.difference(firstDayOfYear).inDays + 1;
  }

  String _messageForDate(DateTime date) {
    if (neomMessages.isEmpty) {
      return 'إشعار يومي من نيوم';
    }
    final index = (_dayOfYear(date) - 1) % neomMessages.length;
    return neomMessages[index];
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  // ربط أسماء النغمات بملفات الصوت:
  // Default    → sound.mp3
  // Ringtone 1 → sound2.mp3
  // Ringtone 2 → sound3.mp3
  // Ringtone 3 → sound4.mp3
  Future<void> _playRingtonePreview(String ringtone) async {
    await _audioPlayer?.stop();
    _audioPlayer = AudioPlayer();
    String assetPath = 'sound.mp3';
    if (ringtone == 'Ringtone 1') assetPath = 'sound2.mp3';
    if (ringtone == 'Ringtone 2') assetPath = 'sound3.mp3';
    if (ringtone == 'Ringtone 3') assetPath = 'sound4.mp3';
    await _audioPlayer!.play(AssetSource(assetPath));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      body: Container(
        color: widget.isDarkMode ? null : Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    // Save Button
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2196F3).withOpacity(0.18),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: isSaving
                          ? const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 3,
                                ),
                              ),
                            )
                          : IconButton(
                              onPressed: isSaving
                                  ? null
                                  : () async {
                                      if (selectedDateTime
                                          .isBefore(DateTime.now())) {
                                        customShowSnackBar(
                                          context: context,
                                          content:
                                              'من فضلك اختر وقتًا في المستقبل',
                                          backgroundColor: Colors.red,
                                        );
                                        return;
                                      }
                                      setState(() => isSaving = true);
                                      final generatedLabel =
                                          _messageForDate(selectedDateTime);
                                      Navigator.pop(context);
                                      Future(() async {
                                        final alarmProvider =
                                            Provider.of<AlarmProvider>(
                                          context,
                                          listen: false,
                                        );
                                        await alarmProvider.setAlarm(
                                          label: generatedLabel,
                                          dateTime: selectedDateTime
                                              .toIso8601String(),
                                          alarmDate: selectedDateTime
                                              .toIso8601String(),
                                          repeat:
                                              isDailyRepeat ? 'daily' : 'once',
                                          id: DateTime.now()
                                              .millisecondsSinceEpoch
                                              .hashCode,
                                          milliseconds: selectedDateTime
                                              .millisecondsSinceEpoch,
                                          ringtone: selectedRingtone,
                                          snoozeDuration: selectedSnooze,
                                        );
                                        if (mounted) {
                                          Duration remainingTime =
                                              selectedDateTime
                                                  .difference(DateTime.now());
                                          int hoursRemaining =
                                              remainingTime.inHours;
                                          int minutesRemaining =
                                              remainingTime.inMinutes % 60;
                                          customShowSnackBar(
                                            context: context,
                                            content:
                                                'تم ضبط الإشعار بعد ${hoursRemaining} ساعة و${minutesRemaining} دقيقة من الآن.',
                                            backgroundColor:
                                                const Color(0xFF2196F3),
                                          );
                                        }
                                      });
                                      setState(() => isSaving = false);
                                      await _audioPlayer?.stop();
                                    },
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'إضافة إشعار جديد',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: widget.isDarkMode
                                        ? Colors.white
                                        : const Color(0xFF1A1A1A),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 80,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2196F3),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Back Button
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: widget.isDarkMode
                                      ? Colors.white.withOpacity(0.08)
                                      : Colors.grey.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Content Section
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ModernInputCard(
                        isDarkMode: widget.isDarkMode,
                        icon: Icons.label_outline,
                        title: 'رسالة الإشعار',
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: widget.isDarkMode
                                ? Colors.white.withOpacity(0.04)
                                : Colors.black.withOpacity(0.04),
                          ),
                          child: Text(
                            _messageForDate(selectedDateTime),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: widget.isDarkMode
                                  ? Colors.white
                                  : Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      ModernInputCard(
                        isDarkMode: widget.isDarkMode,
                        icon: Icons.access_time_filled,
                        title: 'وقت الإشعار',
                        child: Container(
                          height: 200,
                          child: CupertinoTheme(
                            data: CupertinoThemeData(
                              brightness: widget.isDarkMode
                                  ? Brightness.dark
                                  : Brightness.light,
                              textTheme: CupertinoTextThemeData(
                                dateTimePickerTextStyle: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: selectedDateTime,
                              use24hFormat: false,
                              backgroundColor: Colors.transparent,
                              onDateTimeChanged: (DateTime dateTime) {
                                final now = DateTime.now();
                                final today =
                                    DateTime(now.year, now.month, now.day);
                                var newSelectedTime = DateTime(
                                  today.year,
                                  today.month,
                                  today.day,
                                  dateTime.hour,
                                  dateTime.minute,
                                );

                                if (newSelectedTime.isBefore(now)) {
                                  newSelectedTime = newSelectedTime
                                      .add(const Duration(days: 1));
                                }
                                setState(
                                    () => selectedDateTime = newSelectedTime);
                              },
                            ),
                          ),
                        ),
                      ),
                      ModernInputCard(
                        isDarkMode: widget.isDarkMode,
                        icon: Icons.music_note,
                        title: 'نغمة الإشعار',
                        child: DropdownButtonFormField<String>(
                          value: selectedRingtone,
                          dropdownColor: widget.isDarkMode
                              ? const Color(0xFF23242B)
                              : Colors.white,
                          style: TextStyle(
                            color: widget.isDarkMode
                                ? Colors.white
                                : Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'اختر النغمة',
                            hintStyle: TextStyle(
                              color: widget.isDarkMode
                                  ? Colors.white70
                                  : Colors.black54,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: widget.isDarkMode
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: widget.isDarkMode
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF2196F3),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          items: ringtones.map((String ringtone) {
                            return DropdownMenuItem<String>(
                              value: ringtone,
                              child: Text(
                                _ringtoneLabel(ringtone),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) async {
                            if (value != null) {
                              setState(() => selectedRingtone = value);
                              await _playRingtonePreview(value);
                            }
                          },
                        ),
                      ),
                      ModernInputCard(
                        isDarkMode: widget.isDarkMode,
                        icon: Icons.snooze,
                        title: 'مدة الغفوة',
                        child: DropdownButtonFormField<int>(
                          value: selectedSnooze,
                          dropdownColor: widget.isDarkMode
                              ? const Color(0xFF23242B)
                              : Colors.white,
                          style: TextStyle(
                            color: widget.isDarkMode
                                ? Colors.white
                                : Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'اختر مدة الغفوة',
                            hintStyle: TextStyle(
                              color: widget.isDarkMode
                                  ? Colors.white70
                                  : Colors.black54,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: widget.isDarkMode
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: widget.isDarkMode
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF2196F3),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          items: [5, 10, 15].map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(
                                '$value دقائق',
                                textAlign: TextAlign.right,
                              ),
                            );
                          }).toList(),
                          onChanged: (int? value) {
                            if (value != null) {
                              setState(() => selectedSnooze = value);
                            }
                          },
                        ),
                      ),
                      ModernInputCard(
                        isDarkMode: widget.isDarkMode,
                        icon: Icons.repeat,
                        title: 'تكرار يومي',
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'كرر هذا الإشعار كل يوم',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Switch(
                              value: isDailyRepeat,
                              onChanged: (value) =>
                                  setState(() => isDailyRepeat = value),
                              activeColor: const Color(0xFF2196F3),
                              activeTrackColor:
                                  const Color(0xFF2196F3).withOpacity(0.3),
                              inactiveThumbColor: widget.isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey,
                              inactiveTrackColor: widget.isDarkMode
                                  ? Colors.white24
                                  : Colors.grey.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
