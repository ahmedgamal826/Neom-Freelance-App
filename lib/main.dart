// import 'package:flutter/material.dart';

// import 'core/Services/App/app.service.dart';
// import 'core/Services/Auth/auth_service.dart';
// import 'core/Services/Firebase/firebase.service.dart';
// import 'features/authentication/presentation/screens/sign_in.screen.dart';
// import 'features/home/presentation/screens/home_screen.dart';

// Future<void> main() async {
//   //t2 Initialize Flutter Bindings
//   WidgetsFlutterBinding.ensureInitialized();

//   // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
//   // SystemUiOverlay.top,
//   // ]);
//   //t2 Preserve splash screen
//   // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//   //t2 Initialize Services
//   //
//   await App.initialize(AppEnvironment.dev);
//   await FirebaseService.initialize();

//   //
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: StreamBuilder(
//         stream: AuthService().isUserLoggedIn(),
//         builder: (builder, snapshot) {
//           if (snapshot.hasData) {
//             return const HomeScreen();
//           } else {
//             return const SignInScreen();
//           }
//         },
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // ✅ مهم

import 'core/Services/App/app.service.dart';
import 'core/Services/Auth/auth_service.dart';
import 'core/Services/Firebase/firebase.service.dart';
import 'features/authentication/presentation/screens/sign_in.screen.dart';
import 'features/home/presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تحميل ملف .env
  await dotenv.load(fileName: "dev.env");

  // Initialize Services
  await App.initialize(AppEnvironment.dev);
  await FirebaseService.initialize();

  // 🔥 تأكيد إن القيمة اتقرت
  print("BASE URL: ${dotenv.env['NEOM_API_BASE_URL']}");

  runApp(const MyApp());
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
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}
