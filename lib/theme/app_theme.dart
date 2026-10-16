import 'package:flutter/material.dart';

import 'package:energetic_selfcare/config/editable.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData dark() {
    const ink = Editable.parchment;
    const muted = Editable.mist;
    final scheme = ColorScheme.dark(
      surface: Colors.black,
      primary: Editable.shieldGold,
      onPrimary: Colors.black,
      secondary: Editable.accentTeal,
      onSecondary: Colors.black,
      onSurface: ink,
      surfaceContainerHighest: const Color(0xFF161616),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.black,
      canvasColor: Colors.black,
      splashColor: Editable.shieldGold.withValues(alpha: 0.14),
      highlightColor: Colors.white.withValues(alpha: 0.04),
      dividerColor: Editable.shieldGold.withValues(alpha: 0.28),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4,
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: ink,
          fontSize: 28,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
          height: 1.2,
        ),
        headlineSmall: TextStyle(
          color: ink,
          fontSize: 22,
          fontWeight: FontWeight.w400,
          height: 1.25,
        ),
        titleLarge: TextStyle(
          color: ink,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
        titleMedium: TextStyle(
          color: ink,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.35,
        ),
        bodyLarge: TextStyle(
          color: ink,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          color: muted,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        labelLarge: TextStyle(
          color: Editable.shieldGold,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: Editable.shieldGold),
      ),
      iconTheme: const IconThemeData(color: ink),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Editable.shieldGold,
        linearTrackColor: Color(0xFF2A2A2A),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF1C1C1C),
        contentTextStyle: TextStyle(color: ink),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Color(0xFF141414),
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        contentTextStyle: TextStyle(color: ink, fontSize: 16, height: 1.4),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF121212),
        modalBackgroundColor: Color(0xFF121212),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Editable.shieldGold;
          }
          return muted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Editable.shieldGold.withValues(alpha: 0.35);
          }
          return const Color(0xFF2C2C2C);
        }),
      ),
    );
  }
}
