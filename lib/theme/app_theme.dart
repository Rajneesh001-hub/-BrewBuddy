import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// BrewBuddy Design System
/// All colors, typography, and theme configuration live here.
/// Never hardcode these values in screen or widget files.

// ─── Color Palette ────────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  /// Deep forest green — app bars, headings, nav bar active
  static const Color deepGreen = Color(0xFF1E3932);

  /// Fresh green — primary buttons, CTAs, highlights
  static const Color freshGreen = Color(0xFF00704A);

  /// Warm cream — page backgrounds
  static const Color cream = Color(0xFFF2F0EB);

  /// Caramel gold — stars, Gold tier badge, price highlights
  static const Color caramelGold = Color(0xFFC8A36B);

  /// Pure white — cards, sheets
  static const Color white = Color(0xFFFFFFFF);

  /// Light grey — dividers, disabled slots
  static const Color lightGrey = Color(0xFFE8E8E8);

  /// Medium grey — secondary text, subtitles
  static const Color mediumGrey = Color(0xFF9B9B9B);

  /// Dark text — primary body text
  static const Color darkText = Color(0xFF1A1A1A);

  /// Error / remove red
  static const Color errorRed = Color(0xFFD32F2F);

  /// Success green (lighter shade for backgrounds)
  static const Color successGreenLight = Color(0xFFE8F5E9);

  /// Deep green with opacity — used for tinted containers
  static Color deepGreenLight = const Color(0xFF1E3932).withValues(alpha: 0.08);

  /// Gold tint background for birthday/gold tier banners
  static const Color goldLight = Color(0xFFFFF8EC);

  /// Shadow color
  static Color shadowColor = Colors.black.withValues(alpha: 0.08);
}

// ─── Text Styles ──────────────────────────────────────────────────────────────

class AppTextStyles {
  AppTextStyles._();

  // Poppins — headings
  static TextStyle get h1 => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.deepGreen,
        height: 1.2,
      );

  static TextStyle get h2 => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.deepGreen,
        height: 1.3,
      );

  static TextStyle get h3 => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.deepGreen,
        height: 1.3,
      );

  static TextStyle get h4 => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.deepGreen,
        height: 1.4,
      );

  static TextStyle get h5 => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.deepGreen,
        height: 1.4,
      );

  // Inter — body text
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.darkText,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.darkText,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.mediumGrey,
        height: 1.5,
      );

  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.darkText,
        height: 1.4,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.darkText,
        height: 1.4,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.mediumGrey,
        height: 1.4,
      );

  static TextStyle get price => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.freshGreen,
      );

  static TextStyle get priceSmall => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.freshGreen,
      );

  static TextStyle get buttonText => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        letterSpacing: 0.3,
      );

  static TextStyle get chipText => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.deepGreen,
      );

  static TextStyle get starBalance => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.caramelGold,
      );

  static TextStyle get appBarTitle => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
        letterSpacing: 0.2,
      );

  static TextStyle get sectionTitle => GoogleFonts.poppins(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.deepGreen,
      );

  static TextStyle get greeting => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.deepGreen,
      );

  static TextStyle get timerText => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
        letterSpacing: 1.5,
      );

  static TextStyle get tierBadge => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
        letterSpacing: 0.5,
      );
}

// ─── Dimensions ───────────────────────────────────────────────────────────────

class AppDimensions {
  AppDimensions._();

  static const double cornerRadius = 16.0;
  static const double cornerRadiusSmall = 8.0;
  static const double cornerRadiusLarge = 24.0;
  static const double cornerRadiusPill = 100.0;

  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  static const double iconS = 16.0;
  static const double iconM = 20.0;
  static const double iconL = 24.0;
  static const double iconXL = 32.0;

  static const double cardElevation = 0.0;
  static const double bottomNavHeight = 72.0;
}

// ─── Decoration Helpers ───────────────────────────────────────────────────────

class AppDecorations {
  AppDecorations._();

  /// Standard white card with soft shadow
  static BoxDecoration get card => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  /// Deep green gradient for banners
  static BoxDecoration get deepGreenGradient => BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3932), Color(0xFF2D5247)],
        ),
      );

  /// Happy hour green gradient
  static BoxDecoration get happyHourGradient => BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00704A), Color(0xFF1E3932)],
        ),
      );

  /// Gold gradient for Gold tier banner
  static BoxDecoration get goldGradient => BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFC8A36B), Color(0xFFE8C080)],
        ),
      );
}

// ─── Main Theme ───────────────────────────────────────────────────────────────

class AppTheme {
  AppTheme._();

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.freshGreen,
          primary: AppColors.freshGreen,
          secondary: AppColors.caramelGold,
          surface: AppColors.cream,
          error: AppColors.errorRed,
          onPrimary: AppColors.white,
          onSecondary: AppColors.deepGreen,
          onSurface: AppColors.darkText,
        ),
        scaffoldBackgroundColor: AppColors.cream,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.deepGreen,
          foregroundColor: AppColors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: AppTextStyles.appBarTitle,
          iconTheme: const IconThemeData(color: AppColors.white),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.deepGreen,
          unselectedItemColor: AppColors.mediumGrey,
          selectedLabelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
          elevation: 8,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.freshGreen,
            foregroundColor: AppColors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.cornerRadiusPill),
            ),
            minimumSize: const Size(double.infinity, 52),
            textStyle: AppTextStyles.buttonText,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.freshGreen,
            side: const BorderSide(color: AppColors.freshGreen, width: 1.5),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.cornerRadiusPill),
            ),
            minimumSize: const Size(double.infinity, 52),
            textStyle: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.freshGreen,
            textStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.lightGrey,
          selectedColor: AppColors.deepGreen,
          labelStyle: AppTextStyles.chipText,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppDimensions.cornerRadiusPill),
          ),
          side: BorderSide.none,
        ),
        cardTheme: CardThemeData(
          color: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
          ),
          margin: EdgeInsets.zero,
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.lightGrey,
          thickness: 1,
          space: 1,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppDimensions.cornerRadiusPill),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppDimensions.cornerRadiusPill),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppDimensions.cornerRadiusPill),
            borderSide:
                const BorderSide(color: AppColors.freshGreen, width: 1.5),
          ),
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.mediumGrey,
          ),
          prefixIconColor: AppColors.mediumGrey,
        ),
        tabBarTheme: TabBarThemeData(
          labelColor: AppColors.deepGreen,
          unselectedLabelColor: AppColors.mediumGrey,
          labelStyle: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          indicatorSize: TabBarIndicatorSize.label,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
              color: AppColors.freshGreen,
              width: 2.5,
            ),
          ),
        ),
        textTheme: TextTheme(
          headlineLarge: AppTextStyles.h1,
          headlineMedium: AppTextStyles.h2,
          headlineSmall: AppTextStyles.h3,
          titleLarge: AppTextStyles.h4,
          titleMedium: AppTextStyles.h5,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
          labelLarge: AppTextStyles.labelLarge,
          labelMedium: AppTextStyles.labelMedium,
          labelSmall: AppTextStyles.labelSmall,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.freshGreen,
          linearTrackColor: AppColors.lightGrey,
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: AppColors.freshGreen,
          thumbColor: AppColors.freshGreen,
          inactiveTrackColor: AppColors.lightGrey,
        ),
      );
}
