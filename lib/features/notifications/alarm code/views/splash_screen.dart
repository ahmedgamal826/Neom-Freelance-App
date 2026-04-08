// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';
// import 'dart:math';
// import 'home_page.dart';
// import 'widgets/splash_icon.dart';
// import 'widgets/splash_particles.dart';
// import 'widgets/splash_title.dart';
// import 'widgets/splash_decorative_circle.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _logoController;
//   late AnimationController _textController;
//   late AnimationController _fadeController;
//   late AnimationController _pulseController;
//   late AnimationController _particleController;

//   late Animation<double> _logoScaleAnimation;
//   late Animation<Offset> _textSlideAnimation;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _pulseAnimation;
//   late Animation<double> _particleAnimation;

//   // Use Particle from splash_particles.dart
//   final List<Particle> _particles = [];
//   bool isDarkMode = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeParticles();
//     _loadDarkModePreference();
//     _initializeAnimations();
//   }

//   Future<void> _loadDarkModePreference() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       isDarkMode = prefs.getBool('isDarkMode') ?? false;
//     });
//   }

//   void _initializeParticles() {
//     final random = Random();
//     for (int i = 0; i < 25; i++) {
//       _particles.add(Particle(
//         x: random.nextDouble() * 400,
//         y: random.nextDouble() * 800,
//         size: random.nextDouble() * 5 + 1,
//         speed: random.nextDouble() * 2 + 0.5,
//         opacity: random.nextDouble() * 0.6 + 0.2,
//       ));
//     }
//   }

//   void _initializeAnimations() {
//     _logoController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );
//     _textController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _pulseController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//     _particleController = AnimationController(
//       duration: const Duration(milliseconds: 3000),
//       vsync: this,
//     );
//     _logoScaleAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _logoController,
//       curve: Curves.elasticOut,
//     ));
//     _textSlideAnimation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _textController,
//       curve: Curves.easeOutCubic,
//     ));
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeInOut,
//     ));
//     _pulseAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.2,
//     ).animate(CurvedAnimation(
//       parent: _pulseController,
//       curve: Curves.easeInOut,
//     ));
//     _particleAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _particleController,
//       curve: Curves.easeInOut,
//     ));
//     _startAnimations();
//   }

//   void _startAnimations() async {
//     _particleController.repeat();
//     _logoController.forward();
//     await Future.delayed(const Duration(milliseconds: 1000));
//     _textController.forward();
//     _fadeController.forward();
//     _pulseController.repeat(reverse: true);
//     Timer(const Duration(milliseconds: 2000), () {
//       Navigator.of(context).pushReplacement(
//         PageRouteBuilder(
//           pageBuilder: (context, animation, secondaryAnimation) =>
//               const AlaramHomeScreen(),
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             return FadeTransition(
//               opacity: animation,
//               child: child,
//             );
//           },
//           transitionDuration: const Duration(milliseconds: 1000),
//         ),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _logoController.dispose();
//     _textController.dispose();
//     _fadeController.dispose();
//     _pulseController.dispose();
//     _particleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: isDarkMode
//               ? const LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Color(0xFF0D0D0D),
//                     Color(0xFF121212),
//                     Color(0xFF1A1A1A),
//                     Color(0xFF0A0A0A),
//                   ],
//                   stops: [0.0, 0.3, 0.7, 1.0],
//                 )
//               : const LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Color(0xFF2196F3),
//                     Color(0xFF1976D2),
//                     Color(0xFF0D47A1),
//                     Color(0xFF1565C0),
//                   ],
//                   stops: [0.0, 0.3, 0.7, 1.0],
//                 ),
//         ),
//         child: Stack(
//           children: [
//             // Animated particles
//             AnimatedBuilder(
//               animation: _particleController,
//               builder: (context, child) {
//                 return SplashParticles(
//                   animation: _particleAnimation,
//                   particles: _particles,
//                   isDarkMode: isDarkMode,
//                 );
//               },
//             ),
//             SafeArea(
//               child: Column(
//                 children: [
//                   // Top decorative elements
//                   Expanded(
//                     flex: 1,
//                     child: FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: Container(
//                         padding: const EdgeInsets.all(20),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             SplashDecorativeCircle(
//                                 size: 0.8, isDarkMode: isDarkMode),
//                             SplashDecorativeCircle(
//                                 size: 0.6, isDarkMode: isDarkMode),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Main content area
//                   Expanded(
//                     flex: 3,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         AnimatedBuilder(
//                           animation: _logoController,
//                           builder: (context, child) {
//                             return Transform.scale(
//                               scale: _logoScaleAnimation.value,
//                               child: AnimatedBuilder(
//                                 animation: _pulseController,
//                                 builder: (context, child) {
//                                   return Transform.scale(
//                                     scale: _pulseAnimation.value,
//                                     child: SplashIcon(isDarkMode: isDarkMode),
//                                   );
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 40),
//                         SplashTitle(
//                           isDarkMode: isDarkMode,
//                           fadeAnimation: _fadeAnimation,
//                           slideAnimation: _textSlideAnimation,
//                           textFadeAnimation: _textController,
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Bottom decorative elements
//                   Expanded(
//                     flex: 1,
//                     child: FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: Container(
//                         padding: const EdgeInsets.all(20),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             SplashDecorativeCircle(
//                                 size: 0.4, isDarkMode: isDarkMode),
//                             SplashDecorativeCircle(
//                                 size: 0.7, isDarkMode: isDarkMode),
//                             SplashDecorativeCircle(
//                                 size: 0.5, isDarkMode: isDarkMode),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
