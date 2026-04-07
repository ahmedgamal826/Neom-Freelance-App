import 'dart:async';

import 'package:flutter/material.dart';
import 'package:neon/features/notifications/alarm%20code/widgets/clock_painter.dart';

class ClockView extends StatefulWidget {
  final double size;
  final bool isDarkMode;

  const ClockView({
    Key? key,
    required this.size,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<ClockView> createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: ClockPainter(isDarkMode: widget.isDarkMode),
      ),
    );
  }
}
