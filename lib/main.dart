import 'package:flutter/material.dart';
import 'pages/splash_page.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.instance.init();
  runApp(const MikroHubApp());
}

class MikroHubApp extends StatelessWidget {
  const MikroHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MikroHub UMKM',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: NotificationService.messengerKey,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5CC8CC),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          foregroundColor: Color(0xFF202124),
          elevation: 0,
        ),
      ),
      // Halaman pertama: splash, lalu otomatis ke pilihan daftar/masuk
      home: const SplashPage(),
    );
  }
}
