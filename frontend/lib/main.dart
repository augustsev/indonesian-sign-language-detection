import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/huruf_screen.dart';
import 'widgets/dark_mode.dart';
import 'screens/huruf_tab.dart';
import 'screens/home_screen.dart';
import 'screens/kosakata_tab.dart';
// import 'screens/about_screen.dart';
void main() {
  runApp(ThemeController(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override  
  Widget build(BuildContext context) {
    final theme = ThemeController.of(context);

  return MaterialApp(
    title: 'Penerjemah BISINDO',
    debugShowCheckedModeBanner: false,
    themeMode: theme.themeMode,

    theme: ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      primaryColor: const Color(0xFF2563EB),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2563EB),
        secondary: Color(0xFF38BDF8),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF0F172A),
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Color(0xFF0F172A)),
      ),
    ),

    darkTheme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      primaryColor: const Color(0xFF38BDF8),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF38BDF8),
        secondary: Color(0xFF2563EB),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    ),

    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(),
      '/home': (context) {
        final theme = ThemeController.of(context);
        return HomeScreen(
          toggleTheme: (_) => theme.toggleTheme(),
          isDarkMode: theme.isDarkMode,
        );
      },
      '/deteksi': (context) => const HurufScreen(),
      '/kamus_huruf': (context) => const KamusHurufScreen(),
      '/kamus_kosakata': (context) => const KamusKosakataScreen(),
      // '/about': (context) => const TentangAplikasiScreen(),
    },
  );
  }
}
