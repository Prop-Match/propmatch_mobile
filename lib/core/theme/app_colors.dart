import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary & Dark Surfaces
  static const Color primary = Color(0xFF0F172A); // Deep Slate Navy
  static const Color primaryLight = Color(0xFF1E293B);
  static const Color primaryDark = Color(0xFF020617);

  // Accent & Match Highlights
  static const Color accent = Color(0xFF0D9488); // Teal
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue

  // Neutrals & Backgrounds
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Match Score Colors
  static const Color matchHigh = Color(0xFF10B981); // >75%
  static const Color matchMedium = Color(0xFFF59E0B); // 50-75%
  static const Color matchLow = Color(0xFF64748B); // <50%
}
