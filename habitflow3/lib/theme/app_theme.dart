import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryLight = Color(0xFF5E72E4); // Modern indigo
  static const Color primaryDark = Color(0xFF8A98E8); // Lighter indigo for dark mode
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF7F8FC); // Almost white
  static const Color backgroundDark = Color(0xFF1A1F38); // Deep blue-grey
  
  // Card/Surface Colors
  static const Color surfaceLight = Color(0xFFFFFFFF); // White
  static const Color surfaceDark = Color(0xFF252B43); // Slightly lighter than background dark
  
  // Accent Colors
  static const Color accentLight = Color(0xFF11CDEF); // Cyan
  static const Color accentDark = Color(0xFF32BACC); // Slightly muted cyan for dark mode
  
  // Success/Error Colors
  static const Color successColor = Color(0xFF2DCE89); // Green
  static const Color errorColor = Color(0xFFF5365C); // Red
  static const Color warningColor = Color(0xFFFFB236); // Orange/Amber
  
  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000); // Black with opacity
  static const Color shadowDark = Color(0x1A000000); // Also black with opacity
  
  // Text Colors
  static const Color textPrimaryLight = Color(0xFF2D3748);
  static const Color textSecondaryLight = Color(0xFF718096);
  static const Color textPrimaryDark = Color(0xFFE2E8F0);
  static const Color textSecondaryDark = Color(0xFFA0AEC0);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryLight,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: primaryLight,
      secondary: accentLight,
      error: errorColor,
      surface: surfaceLight,
      background: backgroundLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryLight,
      elevation: 4,
      shadowColor: shadowLight,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardTheme(
      color: surfaceLight,
      elevation: 4,
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: textSecondaryLight.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: textSecondaryLight.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      hintStyle: TextStyle(color: textSecondaryLight.withOpacity(0.6)),
      labelStyle: TextStyle(color: textSecondaryLight),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        shadowColor: primaryLight.withOpacity(0.5),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: primaryLight,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: textPrimaryLight),
      bodyMedium: TextStyle(color: textPrimaryLight),
      bodySmall: TextStyle(color: textSecondaryLight),
      labelLarge: TextStyle(color: textPrimaryLight),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: primaryLight,
      unselectedItemColor: textSecondaryLight,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      foregroundColor: Colors.white,
    ),
    dividerTheme: DividerThemeData(
      color: textSecondaryLight.withOpacity(0.2),
      thickness: 1,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryLight;
        }
        return Colors.transparent;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryLight;
        }
        return textSecondaryLight;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryLight;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryLight.withOpacity(0.4);
        }
        return Colors.grey.withOpacity(0.4);
      }),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryDark,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: primaryDark,
      secondary: accentDark,
      error: errorColor,
      surface: surfaceDark,
      background: backgroundDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceDark,
      elevation: 4,
      shadowColor: shadowDark,
      iconTheme: IconThemeData(color: textPrimaryDark),
      titleTextStyle: TextStyle(
        color: textPrimaryDark,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardTheme(
      color: surfaceDark,
      elevation: 4,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: textSecondaryDark.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: textSecondaryDark.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      hintStyle: TextStyle(color: textSecondaryDark.withOpacity(0.6)),
      labelStyle: TextStyle(color: textSecondaryDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        shadowColor: primaryDark.withOpacity(0.5),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: primaryDark,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: textPrimaryDark),
      bodyMedium: TextStyle(color: textPrimaryDark),
      bodySmall: TextStyle(color: textSecondaryDark),
      labelLarge: TextStyle(color: textPrimaryDark),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryDark,
      unselectedItemColor: textSecondaryDark,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryDark,
      foregroundColor: Colors.white,
    ),
    dividerTheme: DividerThemeData(
      color: textSecondaryDark.withOpacity(0.2),
      thickness: 1,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryDark;
        }
        return Colors.transparent;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryDark;
        }
        return textSecondaryDark;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryDark;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryDark.withOpacity(0.4);
        }
        return Colors.grey.withOpacity(0.4);
      }),
    ),
  );
}
