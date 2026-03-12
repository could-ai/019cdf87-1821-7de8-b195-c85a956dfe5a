import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NanoAiApp());
}

class NanoAiApp extends StatelessWidget {
  const NanoAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nano AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0E11), // Dark trading background
        primaryColor: const Color(0xFF00C853), // Profit Green
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00C853),
          secondary: Color(0xFFD50000), // Loss/Down Red
          surface: Color(0xFF1E2329), // Card background
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E2329),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}
