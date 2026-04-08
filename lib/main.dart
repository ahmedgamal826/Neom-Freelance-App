import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // ✅ مهم
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:neon/features/notifications/alarm%20code/utils/alarm_provider.dart';
import 'package:neon/features/notifications/alarm%20code/utils/notification_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/Services/App/app.service.dart';
import 'core/Services/Auth/auth_service.dart';
import 'core/Services/Firebase/firebase.service.dart';
import 'features/authentication/presentation/screens/sign_in.screen.dart';
import 'features/home/presentation/screens/home_screen.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // timezone
  tz.initializeTimeZones();

  // Initialize notifications
  await NotificationHelper.init();

  // Initialize timezone data
  tz.initializeTimeZones();

  await _initializeApp();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AlarmProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _initializeApp() async {
  final status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }

  // ✅ تحميل ملف .env
  await dotenv.load(fileName: "dev.env");

  // Initialize Services
  await App.initialize(AppEnvironment.dev);
  await FirebaseService.initialize();

  // 🔥 تأكيد إن القيمة اتقرت
  debugPrint("BASE URL: ${dotenv.env['NEOM_API_BASE_URL']}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: AuthService().isUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data != null) {
            return const HomeScreen();
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}
