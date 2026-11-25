import 'package:flutter/material.dart';

/// Palet warna pastel: burgundy, olive, light yellow, pastel blue/pink/green
class PastelColors {
  // --- Primary Palette ---
  static const Color burgundy = Color(0xFF8B3A62);
  static const Color burgundyLight = Color(0xFFF2D5E0);
  static const Color burgundySoft = Color(0xFFB56B8A);

  static const Color olive = Color(0xFF7B8B4E);
  static const Color oliveLight = Color(0xFFE8EDCF);
  static const Color oliveSoft = Color(0xFFA3B06D);

  static const Color lightYellow = Color(0xFFFFF8DC);
  static const Color warmYellow = Color(0xFFFFE9A0);
  static const Color goldAccent = Color(0xFFD4A843);

  // --- Pastel Accents ---
  static const Color pastelBlue = Color(0xFFB8D8E8);
  static const Color pastelBlueDark = Color(0xFF6FA3C0);
  static const Color pastelPink = Color(0xFFF5CAC3);
  static const Color pastelPinkDark = Color(0xFFD4847C);
  static const Color pastelGreen = Color(0xFFC5DEAD);
  static const Color pastelGreenDark = Color(0xFF7FAF60);

  // --- Surfaces ---
  static const Color cream = Color(0xFFFFFDF5);
  static const Color cardBg = Color(0xFFFFFCF2);
  static const Color surfaceWarm = Color(0xFFFFF9ED);

  // --- Text ---
  static const Color textDark = Color(0xFF3D2C2E);
  static const Color textMuted = Color(0xFF7A6B6D);
  static const Color textLight = Color(0xFFA99B9D);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSeed(
        seedColor: PastelColors.burgundy,
        brightness: Brightness.light,
        primary: PastelColors.burgundy,
        secondary: PastelColors.olive,
        tertiary: PastelColors.pastelBlue,
        surface: PastelColors.cream,
        onSurface: PastelColors.textDark,
      ),
      scaffoldBackgroundColor: PastelColors.cream,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: PastelColors.textDark,
        titleTextStyle: TextStyle(
          color: PastelColors.textDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: PastelColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: PastelColors.burgundyLight.withValues(alpha: 0.5),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: PastelColors.burgundy,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: PastelColors.burgundyLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: PastelColors.burgundyLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: PastelColors.burgundy, width: 2),
        ),
        hintStyle: const TextStyle(color: PastelColors.textLight, fontSize: 14),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: PastelColors.burgundy,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: PastelColors.burgundy,
        unselectedLabelColor: PastelColors.textLight,
        indicatorColor: PastelColors.burgundy,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: PastelColors.burgundySoft,
        brightness: Brightness.dark,
        surface: const Color(0xFF2A1F24),
      ),
      scaffoldBackgroundColor: const Color(0xFF1E1518),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFF5E6EB),
        titleTextStyle: TextStyle(
          color: Color(0xFFF5E6EB),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF342830),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: PastelColors.burgundySoft.withValues(alpha: 0.3)),
        ),
      ),
    );
  }
}
