// lib/widgets/bottom_cards_widget.dart
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/responsive.dart';
import '../models/prayer_times.dart';

class BottomCardsWidget extends StatelessWidget {
  final PrayerTimesModel prayerTimes;
  final WeatherData weather;

  const BottomCardsWidget({
    super.key,
    required this.prayerTimes,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final scale = getScale(context);
    final nextPrayer = prayerTimes.getNextPrayer();
    final timeLeft = prayerTimes.getTimeLeft();

    return Row(
      children: [
        // الصلاة القادمة
        Expanded(
          child: _BottomCard(
            scale: scale,
            icon: '🕌',
            labelAr: 'الصلاة القادمة',
            labelEn: 'Next Prayer',
            child: Text(
              nextPrayer?.nameAr ?? '--',
              style: AppTextStyles.cardValue(scale),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(width: 12 * scale),
        // الوقت المتبقي
        Expanded(
          child: _BottomCard(
            scale: scale,
            icon: '⏰',
            labelAr: 'الوقت المتبقي',
            labelEn: 'Time Left',
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12 * scale,
                vertical: 4 * scale,
              ),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                timeLeft,
                style: AppTextStyles.cardTimeleft(scale),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        SizedBox(width: 12 * scale),
        // الطقس
        Expanded(
          child: _BottomCard(
            scale: scale,
            icon: '🌡️',
            labelAr: 'درجة الحرارة',
            labelEn: 'Temperature',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  weather.temp,
                  style: AppTextStyles.weatherTemp(scale),
                  textAlign: TextAlign.center,
                ),
                Text(
                  weather.condition,
                  style: AppTextStyles.weatherCondition(scale),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomCard extends StatelessWidget {
  final double scale;
  final String icon;
  final String labelAr;
  final String labelEn;
  final Widget child;

  const _BottomCard({
    required this.scale,
    required this.icon,
    required this.labelAr,
    required this.labelEn,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(18 * scale),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      padding: EdgeInsets.all(10 * scale),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // الملصق
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: TextStyle(fontSize: 14 * scale)),
              SizedBox(width: 4 * scale),
              Flexible(
                child: Text(
                  '$labelAr ',
                  style: AppTextStyles.cardLabel(scale),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            labelEn,
            style: AppTextStyles.cardLabel(scale).copyWith(fontSize: 9 * scale),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6 * scale),
          child,
        ],
      ),
    );
  }
}
