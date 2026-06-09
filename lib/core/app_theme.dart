// lib/core/app_theme.dart
import 'package:flutter/material.dart';

class AppColors {
  // خلفية التطبيق
  static const Color background = Color(0xFFBB9544);

  // حاوية البطاقة الرئيسية
  static const Color cardBg = Color(0xFFD2C46B);

  // البطاقات الداكنة (الساعة، جدول الصلوات، الكروت السفلية)
  static const Color darkCard = Color(0xFF201E17);

  // نص أحمر (الأوقات، العناوين، القيم)
  static const Color redText = Color(0xFFFB0101);

  // نص ذهبي (أسماء الصلوات، الملصقات)
  static const Color goldText = Color(0xFFF9E801);

  // نص داكن (التواريخ، الدعاء)
  static const Color darkText = Color(0xFF0C0C0C);

  // الحدود
  static const Color border = Color(0xFFEEF2F6);

  // خلفية الإعدادات
  static const Color settingsBg = Color(0xFF1E293B);
  static const Color settingsInput = Color(0xFF334155);

  // لون الفاصل
  static const Color separator = Color(0xFFE0E1CB);

  // لون ص/م
  static const Color ampmColor = Color(0xFF9B6A3C);
}

class AppTextStyles {
  static TextStyle title(double scale) => TextStyle(
        fontSize: 36 * scale,
        fontWeight: FontWeight.w900,
        color: AppColors.redText,
        fontFamily: 'NotoNaskhArabic',
      );

  static TextStyle subtitle(double scale) => TextStyle(
        fontSize: 16 * scale,
        fontStyle: FontStyle.italic,
        color: AppColors.darkText,
      );

  static TextStyle clockDigits(double scale) => TextStyle(
        fontSize: 64 * scale,
        fontWeight: FontWeight.w800,
        color: AppColors.redText,
        fontFamily: 'monospace',
        letterSpacing: 4,
      );

  static TextStyle clockLabel(double scale) => TextStyle(
        fontSize: 14 * scale,
        fontWeight: FontWeight.w600,
        color: AppColors.goldText,
        fontFamily: 'NotoNaskhArabic',
      );

  static TextStyle prayerName(double scale) => TextStyle(
        fontSize: 15 * scale,
        fontWeight: FontWeight.w900,
        color: AppColors.goldText,
        fontFamily: 'NotoNaskhArabic',
      );

  static TextStyle prayerTime(double scale) => TextStyle(
        fontSize: 20 * scale,
        fontWeight: FontWeight.w800,
        color: AppColors.redText,
        fontFamily: 'monospace',
      );

  static TextStyle dateText(double scale) => TextStyle(
        fontSize: 14 * scale,
        color: AppColors.darkText,
        fontFamily: 'NotoNaskhArabic',
      );

  static TextStyle cardLabel(double scale) => TextStyle(
        fontSize: 11 * scale,
        fontWeight: FontWeight.w600,
        color: AppColors.goldText,
        fontFamily: 'NotoNaskhArabic',
      );

  static TextStyle cardValue(double scale) => TextStyle(
        fontSize: 24 * scale,
        fontWeight: FontWeight.w800,
        color: AppColors.redText,
        fontFamily: 'NotoNaskhArabic',
      );

  static TextStyle cardTimeleft(double scale) => TextStyle(
        fontSize: 20 * scale,
        fontWeight: FontWeight.w800,
        color: AppColors.redText,
        fontFamily: 'monospace',
      );

  static TextStyle weatherTemp(double scale) => TextStyle(
        fontSize: 28 * scale,
        fontWeight: FontWeight.w700,
        color: AppColors.redText,
      );

  static TextStyle weatherCondition(double scale) => TextStyle(
        fontSize: 12 * scale,
        color: AppColors.redText,
        fontFamily: 'NotoNaskhArabic',
      );

  static TextStyle footerDua(double scale) => TextStyle(
        fontSize: 13 * scale,
        color: AppColors.darkText,
        fontFamily: 'NotoNaskhArabic',
        height: 1.6,
      );

  static TextStyle footerDuaEn(double scale) => TextStyle(
        fontSize: 12 * scale,
        color: AppColors.redText,
        fontStyle: FontStyle.italic,
      );
}
