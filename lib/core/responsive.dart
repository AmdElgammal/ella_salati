// lib/core/responsive.dart
import 'package:flutter/widgets.dart';

/// يحسب معامل التكبير بناءً على عرض الشاشة
/// موبايل ~360px → scale 1.0
/// تابلت 10″ ~768px → scale ~1.6
/// شاشة 32″ ~2560px → scale ~3.5 (مع سقف)
double getScale(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  // نستخدم 440 كعرض مرجعي للموبايل
  final s = (w / 440).clamp(0.85, 3.8);
  return s;
}

/// هل الشاشة تابلت أو أكبر؟
bool isTablet(BuildContext context) {
  return MediaQuery.of(context).size.shortestSide >= 600;
}

/// هل الشاشة TV / شاشة كبيرة؟
bool isLargeScreen(BuildContext context) {
  return MediaQuery.of(context).size.width >= 1200;
}
