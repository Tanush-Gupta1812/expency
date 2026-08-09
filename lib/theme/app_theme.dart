import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/transaction_repository.dart';

// ─── Theme Manager ──────────────────────────────────────────────────────────
class ThemeManager {
  static Color get primaryColor {
    final overall = TransactionRepository.overallBudget;
    if (overall <= 0) return const Color(0xFF00DBE9); // default neon cyan

    final totalExpense = TransactionRepository.transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);

    final ratio = totalExpense / overall;
    if (ratio >= 1.0) {
      return const Color(0xFFFF3B30); // Neon Red
    } else if (ratio >= 0.8) {
      return const Color(0xFFFFCC00); // Neon Yellow
    }
    return const Color(0xFF00DBE9); // Neon Cyan
  }
}

// ─── Dynamic Palette ──────────────────────────────────────────────────────────
Color get kPrimary => ThemeManager.primaryColor;

Color get kPrimaryBright {
  final p = kPrimary;
  if (p == const Color(0xFFFF3B30)) return const Color(0xFFFF7B72); // lighter red
  if (p == const Color(0xFFFFCC00)) return const Color(0xFFFFE066); // lighter yellow
  return const Color(0xFF7DF4FF); // lighter cyan
}

Color get kPrimaryContainer => kPrimary;

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

// ─── Glow helpers ───────────────────────────────────────────────────────────
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

// ─── App Theme ──────────────────────────────────────────────────────────────
ThemeData buildAppTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    scaffoldBackgroundColor: kBackground,
    colorScheme: ColorScheme.dark(
      primary: kPrimary,
      onPrimary: const Color(0xFF000000),
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
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
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
      iconTheme: IconThemeData(color: kPrimary),
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
        borderSide: BorderSide(color: kPrimary, width: 1.5),
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
