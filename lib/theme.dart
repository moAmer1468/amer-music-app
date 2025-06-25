import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Light Theme
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF6B4EFF),
    secondary: Color(0xFF03DAC6),
    surface: Color(0xFFFFFBFE),
    background: Color(0xFFFFFBFE),
    error: Color(0xFFBA1A1A),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFF000000),
    onSurface: Color(0xFF1C1B1F),
    onBackground: Color(0xFF1C1B1F),
    onError: Color(0xFFFFFFFF),
    outline: Color(0xFF79747E),
    shadow: Color(0xFF000000),
  ),
  textTheme: GoogleFonts.interTextTheme(
    const TextTheme(
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1C1B1F),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF8B7EFF),
    secondary: Color(0xFF03DAC6),
    surface: Color(0xFF121212),
    background: Color(0xFF0F0F0F),
    error: Color(0xFFCF6679),
    onPrimary: Color(0xFF000000),
    onSecondary: Color(0xFF000000),
    onSurface: Color(0xFFE3E2E6),
    onBackground: Color(0xFFE3E2E6),
    onError: Color(0xFF000000),
    outline: Color(0xFF938F99),
    shadow: Color(0xFF000000),
  ),
  textTheme: GoogleFonts.interTextTheme(
    const TextTheme(
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25, color: Color(0xFFE3E2E6)),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: Color(0xFFE3E2E6)),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: Color(0xFFE3E2E6)),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Color(0xFFE3E2E6)),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Color(0xFFE3E2E6)),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFE3E2E6)),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFFE3E2E6)),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15, color: Color(0xFFE3E2E6)),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: Color(0xFFE3E2E6)),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5, color: Color(0xFFE3E2E6)),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: Color(0xFFE3E2E6)),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: Color(0xFFE3E2E6)),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: Color(0xFFE3E2E6)),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: Color(0xFFE3E2E6)),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: Color(0xFFE3E2E6)),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Color(0xFFE3E2E6),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.3),
    color: const Color(0xFF1E1E1E),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
      backgroundColor: const Color(0xFF8B7EFF),
      foregroundColor: const Color(0xFF000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
);