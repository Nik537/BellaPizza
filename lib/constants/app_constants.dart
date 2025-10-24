// Design System Constants for Calda Pizza Ordering App
// Extracted from Figma Design File
// All values are pixel-perfect from the design specifications

import 'package:flutter/material.dart';

/// App Color Palette
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFBD092A); // rgba(189, 9, 42, 1.0)
  static const Color primaryVariant = Color(0xFFBE0A2A); // rgba(190, 10, 42, 1.0)

  // Background Colors
  static const Color background = Color(0xFFF7F7F7); // rgba(247, 247, 247, 1.0)
  static const Color backgroundLight = Color(0xFFFFFFFF); // White
  static const Color backgroundDark = Color(0xFF280404); // rgba(40, 4, 4, 1.0)

  // Success Colors
  static const Color successLight = Color(0xFFF2FBEE); // rgba(242, 251, 238, 1.0)
  static const Color successMedium = Color(0xFFE1F7D7); // rgba(225, 247, 215, 1.0)

  // Text Colors
  static const Color textPrimary = Color(0xFF202948); // rgba(32, 41, 72, 1.0)
  static const Color textSecondary = Color(0xFF535D67); // rgba(83, 93, 103, 1.0)
  static const Color textDark = Color(0xFF212121); // rgba(33, 33, 33, 1.0)
  static const Color textLight = Color(0xFFFFFFFF); // White

  // Border/Divider Colors
  static const Color divider = Color(0xFFDADADA); // rgba(218, 218, 218, 1.0)

  // Helper method to get color from hex
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

/// Typography System
class AppTypography {
  static const String primaryFont = 'Poppins';

  // Headings
  static const TextStyle h1 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 36,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
  );

  static const TextStyle h5 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Special
  static const TextStyle buttonText = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  static const TextStyle lightText = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondary,
  );
}

/// Spacing System
class AppSpacing {
  // Base spacing unit (8px)
  static const double unit = 8.0;

  // Spacing scale
  static const double xs = unit * 0.5; // 4px
  static const double sm = unit; // 8px
  static const double md = unit * 2; // 16px
  static const double lg = unit * 3; // 24px
  static const double xl = unit * 4; // 32px
  static const double xxl = unit * 6; // 48px

  // Screen padding
  static const double screenPaddingHorizontal = 16.0;
  static const double screenPaddingVertical = 16.0;

  // Component spacing
  static const double cardPadding = 16.0;
  static const double buttonPaddingVertical = 16.0;
  static const double buttonPaddingHorizontal = 16.0;

  // List spacing
  static const double listItemSpacing = 12.0;
  static const double gridSpacing = 12.0;
}

/// Border Radius System
class AppBorderRadius {
  static const double none = 0;
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 24.0;
  static const double full = 120.0; // For buttons and pills

  // BorderRadius objects
  static BorderRadius get circular => BorderRadius.circular(full);
  static BorderRadius get roundedSm => BorderRadius.circular(sm);
  static BorderRadius get roundedMd => BorderRadius.circular(md);
  static BorderRadius get roundedLg => BorderRadius.circular(lg);
  static BorderRadius get roundedXl => BorderRadius.circular(xl);
  static BorderRadius get roundedXxl => BorderRadius.circular(xxl);
}

/// Screen Dimensions
class AppDimensions {
  // Design was created for 390x844 screen
  static const double designWidth = 390.0;
  static const double designHeight = 844.0;

  // Component sizes from design
  static const double buttonHeight = 52.0;
  static const double inputHeight = 48.0;
  static const double tabHeight = 40.0;
  static const double navBarHeight = 100.0;

  // Card sizes
  static const double pizzaCardWidth = 149.0;
  static const double pizzaCardHeight = 200.0;
  static const double addOnSize = 36.11;

  // Icon sizes
  static const double iconSm = 18.0;
  static const double iconMd = 21.0;
  static const double iconLg = 24.0;
  static const double iconXl = 45.0;
}

/// Shadow System
class AppShadows {
  static BoxShadow get light => BoxShadow(
    color: Colors.black.withOpacity(0.05),
    offset: const Offset(0, 2),
    blurRadius: 4,
  );

  static BoxShadow get medium => BoxShadow(
    color: Colors.black.withOpacity(0.10),
    offset: const Offset(0, 4),
    blurRadius: 8,
  );

  static BoxShadow get heavy => BoxShadow(
    color: Colors.black.withOpacity(0.15),
    offset: const Offset(0, 8),
    blurRadius: 16,
  );
}

/// Animation Durations
class AppAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  // Curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeOutCubic;
}

/// App Theme
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.primaryFont,
    scaffoldBackgroundColor: AppColors.background,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryVariant,
      surface: AppColors.backgroundLight,
      background: AppColors.background,
      error: Colors.red,
      onPrimary: AppColors.textLight,
      onSecondary: AppColors.textLight,
      onSurface: AppColors.textPrimary,
      onBackground: AppColors.textPrimary,
    ),

    textTheme: const TextTheme(
      displayLarge: AppTypography.h1,
      displayMedium: AppTypography.h2,
      displaySmall: AppTypography.h3,
      headlineMedium: AppTypography.h4,
      headlineSmall: AppTypography.h5,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      bodySmall: AppTypography.bodySmall,
      labelLarge: AppTypography.labelLarge,
      labelMedium: AppTypography.labelMedium,
      labelSmall: AppTypography.labelSmall,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.circular,
        ),
        textStyle: AppTypography.buttonText,
        elevation: 0,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundLight,
      border: OutlineInputBorder(
        borderRadius: AppBorderRadius.roundedLg,
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.roundedLg,
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.roundedLg,
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.roundedLg,
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
    ),
  );
}
