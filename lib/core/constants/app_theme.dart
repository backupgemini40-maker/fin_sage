import 'package:flutter/material.dart';

class AppTheme {
  static const Color deepTeal = Color(0xFF0B3954);
  static const Color seaGlass = Color(0xFF5CA4A9);
  static const Color amber = Color(0xFFF2A65A);
  static const Color fog = Color(0xFFF4F7F9);
  static const Color darkSurface = Color(0xFF0B1D2A);
  static const Color darkCard = Color(0xFF132B3A);

  static const _textTheme = TextTheme(
    headlineLarge: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.14,
        letterSpacing: -0.6),
    headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.4),
    titleLarge:
        TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 1.24),
    titleMedium:
        TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.32),
    bodyLarge:
        TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
    bodyMedium:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
    labelLarge: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.2),
    labelMedium: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.2),
  );

  static ThemeData get light {
    final scheme =
        ColorScheme.fromSeed(seedColor: deepTeal, brightness: Brightness.light)
            .copyWith(
      primary: deepTeal,
      secondary: amber,
      tertiary: seaGlass,
      surface: Colors.white,
      surfaceTint: deepTeal,
      onPrimary: Colors.white,
      outline: deepTeal.withOpacity(0.16),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'RobotoCondensed',
      colorScheme: scheme,
      scaffoldBackgroundColor: fog,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: deepTeal,
        titleTextStyle: _textTheme.titleLarge?.copyWith(color: deepTeal),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white.withOpacity(0.92),
        indicatorColor: deepTeal.withOpacity(0.14),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.all(
          _textTheme.labelMedium?.copyWith(color: deepTeal.withOpacity(0.86)),
        ),
      ),
      cardTheme: CardTheme(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.white.withOpacity(0.86),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        surfaceTintColor: Colors.white,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: BorderSide(color: deepTeal.withOpacity(0.12)),
        selectedColor: deepTeal.withOpacity(0.16),
        backgroundColor: Colors.white.withOpacity(0.74),
        labelStyle: _textTheme.labelMedium,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: deepTeal,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: deepTeal.withOpacity(0.26)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.92),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: deepTeal.withOpacity(0.14), width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: deepTeal.withOpacity(0.14), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: deepTeal, width: 1.5),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: deepTeal,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get dark {
    final scheme =
        ColorScheme.fromSeed(seedColor: deepTeal, brightness: Brightness.dark)
            .copyWith(
      primary: seaGlass,
      secondary: amber,
      tertiary: deepTeal,
      surface: darkSurface,
      surfaceTint: seaGlass,
      onPrimary: darkSurface,
      outline: Colors.white.withOpacity(0.16),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'RobotoCondensed',
      colorScheme: scheme,
      scaffoldBackgroundColor: darkSurface,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme:
          _textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: _textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkCard.withOpacity(0.96),
        indicatorColor: Colors.white.withOpacity(0.14),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.all(
          _textTheme.labelMedium
              ?.copyWith(color: Colors.white.withOpacity(0.86)),
        ),
      ),
      cardTheme: CardTheme(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: darkCard.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: BorderSide(color: Colors.white.withOpacity(0.18)),
        selectedColor: seaGlass.withOpacity(0.32),
        backgroundColor: darkCard.withOpacity(0.8),
        labelStyle: _textTheme.labelMedium
            ?.copyWith(color: Colors.white.withOpacity(0.9)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard.withOpacity(0.74),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.16), width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.16), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: seaGlass, width: 1.5),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: Colors.white.withOpacity(0.22)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: seaGlass,
        foregroundColor: darkSurface,
      ),
    );
  }
}
