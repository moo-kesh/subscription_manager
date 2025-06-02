import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// App Colors
const Color kPrimaryColor = Color(0xFF026ACB);
const Color kSecondaryColor = Color(0xFF05B862);
const Color kBackgroundColor = Color(0xFF18181C);
const Color kSurfaceColor = Color(0xFF212125);
const Color kTextColor = Colors.white;

// ThemeData
final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: kBackgroundColor,
  primaryColor: kPrimaryColor,
  colorScheme: const ColorScheme.dark(
    primary: kPrimaryColor,
    secondary: kSecondaryColor,
    surface: kSurfaceColor, // For cards, dialogs, etc.
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: kTextColor,
    error: Colors.redAccent,
    onError: Colors.white,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.redHatDisplay(
      color: kTextColor,
      fontWeight: FontWeight.bold,
      // Define specific sizes if needed, e.g., fontSize: 32,
    ),
    displayMedium: GoogleFonts.redHatDisplay(
      color: kTextColor,
      fontWeight: FontWeight.bold,
      // e.g., fontSize: 28,
    ),
    displaySmall: GoogleFonts.redHatDisplay(
      color: kTextColor,
      fontWeight: FontWeight.bold,
      // e.g., fontSize: 24,
    ),
    headlineMedium: GoogleFonts.redHatDisplay(
      color: kTextColor,
      fontWeight: FontWeight.w600, // Semi-bold
      // e.g., fontSize: 20,
    ),
    headlineSmall: GoogleFonts.redHatDisplay(
      color: kTextColor,
      fontWeight: FontWeight.w600,
      // e.g., fontSize: 18,
    ),
    titleLarge: GoogleFonts.redHatDisplay(
      color: kTextColor,
      fontWeight: FontWeight.w500, // Medium
      // e.g., fontSize: 16,
    ),
    bodyLarge: GoogleFonts.unbounded(
      color: kTextColor,
      // e.g., fontSize: 16,
    ),
    bodyMedium: GoogleFonts.redHatDisplay(
      color: kTextColor,
      // e.g., fontSize: 14,
    ),
    bodySmall: GoogleFonts.unbounded(
      color: kTextColor.withValues(
        alpha: 0.8,
      ), // Slightly lighter for less emphasis
      // e.g., fontSize: 12,
    ),
    labelLarge: GoogleFonts.unbounded(
      color: kPrimaryColor, // For button text, often uses primary color
      fontWeight: FontWeight.bold,
      // e.g., fontSize: 16,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.white,
      textStyle: GoogleFonts.unbounded(fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: kBackgroundColor,
    elevation: 0, // No shadow for a flatter look
    iconTheme: const IconThemeData(color: kTextColor),
    titleTextStyle: GoogleFonts.redHatDisplay(
      color: kTextColor,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  cardTheme: CardThemeData(
    color: kSurfaceColor,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: kSurfaceColor,
    selectedColor: kPrimaryColor,
    secondarySelectedColor: kSecondaryColor,
    padding: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  checkboxTheme: CheckboxThemeData(
    // make the checkbox circular
    side: BorderSide(color: kPrimaryColor, width: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
  ),
);
