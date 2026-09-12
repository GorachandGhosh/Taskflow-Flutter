import 'package:flutter/material.dart';

/// App-wide color palette inspired by modern purple/indigo task management UI.
class AppColors {
  AppColors._();

  // Primary Branding (Purple / Indigo)
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF8B85FF);
  static const Color primaryDark = Color(0xFF4B44CC);
  static const Color primaryContainer = Color(0xFFEDEBFD);
  static const Color onPrimaryContainer = Color(0xFF28207E);

  // Secondary Accents
  static const Color secondary = Color(0xFF3F51B5);
  static const Color secondaryContainer = Color(0xFFE8EAF6);

  // Background & Surfaces
  static const Color scaffoldBackground = Color(0xFFF7F8FC);
  static const Color cardSurface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF0F2F8);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E2022);
  static const Color textSecondary = Color(0xFF777E90);
  static const Color textMuted = Color(0xFFA0A6B5);

  // Borders & Dividers
  static const Color border = Color(0xFFE6E8EC);
  static const Color borderFocused = Color(0xFF6C63FF);

  // Priority Colors
  static const Color priorityLow = Color(0xFF22C55E); // Green
  static const Color priorityLowBg = Color(0xFFDCFCE7);

  static const Color priorityMedium = Color(0xFFF59E0B); // Amber/Orange
  static const Color priorityMediumBg = Color(0xFFFEF3C7);

  static const Color priorityHigh = Color(0xFFEF4444); // Red
  static const Color priorityHighBg = Color(0xFFFEE2E2);

  // Status & Alerts
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFE11D48);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Completion State
  static const Color completed = Color(0xFF10B981);
  static const Color completedCard = Color(0xFFF9FAFB);
}
