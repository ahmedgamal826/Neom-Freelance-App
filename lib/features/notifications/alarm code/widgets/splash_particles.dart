import 'package:flutter/material.dart';

class Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class SplashParticles extends StatelessWidget {
  final Animation<double> animation;
  final List<Particle> particles;
  final bool isDarkMode;
  const SplashParticles(
      {Key? key,
      required this.animation,
      required this.particles,
      required this.isDarkMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlePainter(
        particles: particles,
        animation: animation.value,
        isDarkMode: isDarkMode,
      ),
      size: Size.infinite,
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;
  final bool isDarkMode;

  _ParticlePainter(
      {required this.particles,
      required this.animation,
      required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkMode
          ? const Color(0xFF2196F3).withOpacity(0.3)
          : Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      final x = (particle.x + animation * particle.speed * 100) % size.width;
      final y = (particle.y + animation * particle.speed * 50) % size.height;
      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint
          ..color = isDarkMode
              ? const Color(0xFF2196F3).withOpacity(particle.opacity)
              : Colors.white.withOpacity(particle.opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
