import 'package:flutter/material.dart';

class AppColors {
  // General
  static const Color background = Color(
    0xFFFDFDFD,
  ); // very soft white
  static const Color textPrimary = Color(
    0xFF212121,
  ); // dark gray, easier on eyes
  static const Color textSecondary = Color(
    0xFF616161,
  ); // medium gray

  // AppBar & Buttons
  static const Color appBar = Color(
    0xFF1976D2,
  ); // strong blue
  static const Color button = Color(
    0xFF1976D2,
  ); // same blue as app bar
  static const Color buttonText =
      Colors.white; // text on button

  // Cards
  static const Color cardBackground = Color(
    0xFFF5F5F5,
  ); // soft light gray

  // Task Priority (bold and distinct)
  static const Color highPriority = Color(
    0xFFD32F2F,
  ); // deep red
  static const Color mediumPriority = Color(
    0xFFFFA000,
  ); // amber/orange
  static const Color lowPriority = Color(
    0xFF388E3C,
  ); // forest green
}
