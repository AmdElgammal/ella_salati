// lib/widgets/prayer_table_widget.dart
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/responsive.dart';
import '../models/prayer_times.dart';

class PrayerTableWidget extends StatelessWidget {
  final PrayerTimesModel prayerTimes;

  const PrayerTableWidget({super.key, required this.prayerTimes});

  @override
  Widget build(BuildContext context) {
    final scale = getScale(context);
    final prayers = prayerTimes.all;
    final nextPrayer = prayerTimes.getNextPrayer();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(24 * scale),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // العمود العربي
            Expanded(
              child: _PrayerNamesColumn(
                prayers: prayers,
                isArabic: true,
                scale: scale,
                nextKey: nextPrayer?.key,
              ),
            ),
            // الفاصل العمودي
            Container(
                width: 1,
                color: AppColors.border.withAlpha((0.3 * 255).round())),
            // عمود الأوقات
            _TimesColumn(
              prayers: prayers,
              scale: scale,
              nextKey: nextPrayer?.key,
            ),
            // الفاصل العمودي
            Container(
                width: 1,
                color: AppColors.border.withAlpha((0.3 * 255).round())),
            // العمود الإنجليزي
            Expanded(
              child: _PrayerNamesColumn(
                prayers: prayers,
                isArabic: false,
                scale: scale,
                nextKey: nextPrayer?.key,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====== عمود أسماء الصلوات (عربي أو إنجليزي) ======
class _PrayerNamesColumn extends StatelessWidget {
  final List<PrayerTime> prayers;
  final bool isArabic;
  final double scale;
  final String? nextKey;

  const _PrayerNamesColumn({
    required this.prayers,
    required this.isArabic,
    required this.scale,
    this.nextKey,
  });

  static const Map<String, String> _icons = {
    'fajr': '🌙',
    'sunrise': '🌅',
    'dhuhr': '☀️',
    'asr': '🌤️',
    'maghrib': '🌇',
    'isha': '🌃',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: prayers.asMap().entries.map((e) {
        final i = e.key;
        final p = e.value;
        final isLast = i == prayers.length - 1;
        final isNext = p.key == nextKey;

        final name = isArabic ? p.nameAr : p.nameEn;
        final icon = Text(
          _icons[p.key] ?? '🕌',
          style: TextStyle(fontSize: 16 * scale),
        );

        return Container(
          decoration: BoxDecoration(
            color: isNext
                ? AppColors.goldText.withAlpha((0.08 * 255).round())
                : Colors.transparent,
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(
                      color: AppColors.border.withAlpha((0.2 * 255).round()),
                      width: 1,
                    ),
                  ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 10 * scale,
            horizontal: 8 * scale,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: isArabic
                ? [
                    icon,
                    SizedBox(width: 6 * scale),
                    _nameText(name, scale, isNext)
                  ]
                : [
                    _nameText(name, scale, isNext),
                    SizedBox(width: 6 * scale),
                    icon
                  ],
          ),
        );
      }).toList(),
    );
  }

  Widget _nameText(String name, double scale, bool isNext) => Text(
        name,
        style: AppTextStyles.prayerName(scale).copyWith(
          color: isNext
              ? AppColors.goldText
              : AppColors.goldText.withAlpha((0.85 * 255).round()),
          fontWeight: isNext ? FontWeight.w900 : FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      );
}

// ====== عمود الأوقات ======
class _TimesColumn extends StatelessWidget {
  final List<PrayerTime> prayers;
  final double scale;
  final String? nextKey;

  const _TimesColumn({
    required this.prayers,
    required this.scale,
    this.nextKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: prayers.asMap().entries.map((e) {
        final i = e.key;
        final p = e.value;
        final isLast = i == prayers.length - 1;
        final isNext = p.key == nextKey;

        return Container(
          decoration: BoxDecoration(
            color: isNext
                ? AppColors.goldText.withAlpha((0.08 * 255).round())
                : Colors.transparent,
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(
                      color: AppColors.border.withAlpha((0.2 * 255).round()),
                      width: 1,
                    ),
                  ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 10 * scale,
            horizontal: 20 * scale,
          ),
          child: Text(
            p.formatted,
            style: AppTextStyles.prayerTime(scale).copyWith(
              color: isNext ? AppColors.goldText : AppColors.redText,
              fontWeight: isNext ? FontWeight.w900 : FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }
}
