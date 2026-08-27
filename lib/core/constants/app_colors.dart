import 'package:flutter/material.dart';

class AppColors {
  // Primary Greens
  static const Color primary = Color(0xFF1B5E20); // Deep Forest Green
  static const Color primaryLight = Color(0xFF4CAF50); // Leaf Green
  static const Color primaryDark = Color(0xFF003300);
  static const Color primaryContainer = Color(0xFFE8F5E9); // Light Mint

  // Secondary Warm Tones (Soil & Harvest)
  static const Color accentAmber = Color(0xFFF57F17); // Golden Harvest
  static const Color accentOrange = Color(0xFFFF6F00);
  static const Color soilBrown = Color(0xFF5D4037);

  // Surface & Background
  static const Color background = Color(0xFFF9FBF8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F0);
  static const Color border = Color(0xFFE0E5DF);

  // Text
  static const Color textPrimary = Color(0xFF1E271F);
  static const Color textSecondary = Color(0xFF5F6E60);
  static const Color textMuted = Color(0xFF8D9B8E);

  // Status & Badges
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFED6C02);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient harvestGradient = LinearGradient(
    colors: [Color(0xFFE65100), Color(0xFFF57F17)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlow = LinearGradient(
    colors: [Color(0xFFE8F5E9), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
