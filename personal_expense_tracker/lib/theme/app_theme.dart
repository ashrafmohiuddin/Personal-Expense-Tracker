import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class AppTheme {
  // Color palette
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color primaryGreenLight = Color(0xFF81C784);
  static const Color primaryGreenDark = Color(0xFF388E3C);
  
  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color primaryOrangeLight = Color(0xFFFFB74D);
  static const Color primaryOrangeDark = Color(0xFFF57C00);
  
  static const Color primarySand = Color(0xFFF4A460);
  static const Color primarySandLight = Color(0xFFFFDAB9);
  static const Color primarySandDark = Color(0xFFCD853F);
  
  static const Color deepBlack = Color(0xFF1A1A1A);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFF9E9E9E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFE57373);
  static const Color blue = Color(0xFF64B5F6);
  
  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, primaryGreenLight],
    stops: [0.0, 1.0],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryOrange, primaryOrangeLight],
    stops: [0.0, 1.0],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primarySand, primarySandLight],
    stops: [0.0, 1.0],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [white, lightGray],
    stops: [0.0, 1.0],
  );

  // Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.green,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: lightGray,
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        foregroundColor: deepBlack,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: deepBlack,
        ),
      ),
      cardTheme: CardThemeData(
        color: white,
        elevation: 2,
        shadowColor: deepBlack.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: white,
          elevation: 2,
          shadowColor: primaryGreen.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: mediumGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        filled: true,
        fillColor: white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: primaryOrange,
        surface: white,
        error: red,
        onPrimary: white,
        onSecondary: white,
        onSurface: deepBlack,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  // Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.green,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: white,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF2A2A2A),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: white,
          elevation: 2,
          shadowColor: primaryGreen.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF555555)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        secondary: primaryOrange,
        surface: Color(0xFF2A2A2A),
        error: red,
        onPrimary: white,
        onSecondary: white,
        onSurface: white,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  // Text styles - these will be used with theme context
  static TextStyle headingStyle(BuildContext context) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle subheadingStyle(BuildContext context) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle bodyStyle(BuildContext context) => TextStyle(
    fontSize: 16,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle captionStyle(BuildContext context) => TextStyle(
    fontSize: 14,
    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
  );

  // Spacing constants
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  
  // Animation constants
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  static const Curve animationCurve = Curves.easeInOut;
  static const Curve animationCurveFast = Curves.easeOut;
  static const Curve animationCurveSlow = Curves.easeInOutCubic;
  
  // Platform-specific constants
  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  
  // Responsive breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
} 