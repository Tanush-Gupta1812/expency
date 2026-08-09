import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// â”€â”€â”€ Neon Cyan Palette â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
const kPrimary = Color(0xFF00DBE9);       // Neon Cyan (primary-fixed-dim)
const kPrimaryBright = Color(0xFF7DF4FF); // Lighter cyan
const kPrimaryContainer = Color(0xFF00F0FF);
const kIncome = Color(0xFF00FF00);        // Lime Green
const kExpense = Color(0xFFFF00FF);       // Electric Magenta
const kBackground = Color(0xFF000000);    // Pitch black
const kSurface = Color(0xFF1A1A1A);       // Level-1 card
const kSurfaceVariant = Color(0xFF111111);
const kOnSurface = Color(0xFFDCE4E5);
const kOnSurfaceVariant = Color(0xFFB9CACB);
const kOutline = Color(0xFF3B494B);
const kError = Color(0xFFFFB4AB);
const kCardBg = Color(0x801A1A1A);        // 50% alpha for glass cards

// â”€â”€â”€ Glow helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
BoxDecoration glassCard({bool active = false, Color? glowColor}) {
  final glow = glowColor ?? kPrimary;
  return BoxDecoration(
    color: kCardBg,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: glow.withValues(alpha: active ? 0.8 : 0.2),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: glow.withValues(alpha: active ? 0.4 : 0.15),
        blurRadius: active ? 20 : 12,
        spreadRadius: 0,
      ),
    ],
  );
}

BoxDecoration neonBorderDecoration({Color? color, double radius = 12}) {
  final c = color ?? kPrimary;
  return BoxDecoration(
    color: c.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: c.withValues(alpha: 0.5), width: 1),
    boxShadow: [BoxShadow(color: c.withValues(alpha: 0.25), blurRadius: 10)],
  );
}

// â”€â”€â”€ App Theme â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
ThemeData buildAppTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    scaffoldBackgroundColor: kBackground,
    colorScheme: const ColorScheme.dark(
      primary: kPrimary,
      onPrimary: Color(0xFF000000),
      secondary: kExpense,
      onSecondary: Colors.white,
      surface: kSurface,
      onSurface: kOnSurface,
      error: kError,
    ),
    textTheme: GoogleFonts.spaceGroteskTextTheme(base.textTheme).apply(
      bodyColor: kOnSurface,
      displayColor: kOnSurface,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      selectedItemColor: kPrimary,
      unselectedItemColor: kOnSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.spaceGrotesk(
        color: kPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 4,
      ),
      iconTheme: const IconThemeData(color: kPrimary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kPrimary.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kPrimary.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimary, width: 1.5),
      ),
      hintStyle: GoogleFonts.spaceGrotesk(
        color: kOnSurfaceVariant,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 1,
        ),
      ),
    ),
  );
}

