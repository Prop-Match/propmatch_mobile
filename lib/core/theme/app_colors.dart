import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary & Dark Surfaces (matching propmatch_frontend globals.css)
  static const Color primary = Color(0xFF0E7C86); // Brand Teal
  static const Color primaryDark = Color(0xFF0B5F67);
  static const Color primaryLight = Color(0xFF145A63); // Landing Mid
  static const Color primaryTint = Color(0xFFE6F4F5);

  // Trust Accent
  static const Color trustBlue = Color(0xFF1F6FEB);
  static const Color trustBlueTint = Color(0xFFE7F0FE);

  // State colors
  static const Color accent = Color(0xFF0E7C86);
  static const Color success = Color(0xFF16A34A);
  static const Color successTint = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color pendingTint = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorTint = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF1F6FEB);
  static const Color pending = Color(0xFFF59E0B);

  // Neutrals & Backgrounds
  static const Color background = Color(0xFFF7FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Ink
  static const Color textSecondary = Color(0xFF334155); // Body Text
  static const Color textMuted = Color(0xFF64748B); // Muted
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Match Score Colors
  static const Color matchHigh = Color(0xFF16A34A); // >75%
  static const Color matchMedium = Color(0xFFD97706); // 50-75%
  static const Color matchLow = Color(0xFF64748B); // <50%
}
