import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/tv_show_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TvShowProvider(),
      child: MaterialApp(
        title: 'TV Shows App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6200EA),
            brightness: Brightness.light,
            primary: const Color(0xFF6200EA),
            secondary: const Color(0xFF03DAC6),
            tertiary: const Color(0xFFFF8A65),
            surface: Colors.white,
            background: const Color(0xFFF5F5F6),
            error: const Color(0xFFB00020),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Color(0xFF6200EA),
            foregroundColor: Colors.white,
          ),
          cardTheme: CardTheme(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              backgroundColor: const Color(0xFF6200EA),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          textTheme: const TextTheme(
            headlineMedium: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F1F1F),
            ),
            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F1F1F),
            ),
            bodyLarge: TextStyle(
              color: Color(0xFF424242),
            ),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6200EA),
            brightness: Brightness.dark,
            primary: const Color(0xFFBB86FC),
            secondary: const Color(0xFF03DAC6),
            tertiary: const Color(0xFFFF8A65),
            surface: const Color(0xFF1E1E1E),
            background: const Color(0xFF121212),
            error: const Color(0xFFCF6679),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
          ),
          cardTheme: CardTheme(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              backgroundColor: const Color(0xFFBB86FC),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          textTheme: const TextTheme(
            headlineMedium: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            bodyLarge: TextStyle(
              color: Color(0xFFE0E0E0),
            ),
          ),
        ),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
