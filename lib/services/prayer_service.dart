// lib/services/prayer_service.dart
import 'package:adhan/adhan.dart';
import '../models/prayer_times.dart';
import '../models/settings.dart';

class PrayerService {
  static PrayerTimesModel calculate(AppSettings settings, {DateTime? date}) {
    final d = date ?? DateTime.now();
    final coords = Coordinates(settings.lat, settings.lng);
    final dateComponents = DateComponents(d.year, d.month, d.day);

    // اختيار طريقة الحساب
    CalculationParameters params;
    switch (settings.method) {
      case 'MWL':
        params = CalculationMethod.muslim_world_league.getParameters();
        break;
      case 'Egypt':
        params = CalculationMethod.egyptian.getParameters();
        break;
      case 'UQU':
      default:
        params = CalculationMethod.umm_al_qura.getParameters();
        break;
    }

    final prayerTimes = PrayerTimes(coords, dateComponents, params);

    // تحويل إلى التوقيت المحلي وتطبيق الإزاحات
    PrayerTime _build(String key, String ar, String en, DateTime dt) {
      final offset = settings.offsets[key] ?? 0;
      final adjusted = dt.toLocal().add(Duration(minutes: offset));
      return PrayerTime(
        key: key,
        nameAr: ar,
        nameEn: en,
        hour: adjusted.hour,
        minute: adjusted.minute,
      );
    }

    return PrayerTimesModel(
      fajr: _build('fajr', 'الفجر', 'Fajr', prayerTimes.fajr),
      sunrise: _build('sunrise', 'الشروق', 'Sunrise', prayerTimes.sunrise),
      dhuhr: _build('dhuhr', 'الظهر', 'Dhuhr', prayerTimes.dhuhr),
      asr: _build('asr', 'العصر', 'Asr', prayerTimes.asr),
      maghrib: _build('maghrib', 'المغرب', 'Maghrib', prayerTimes.maghrib),
      isha: _build('isha', 'العشاء', 'Isha', prayerTimes.isha),
    );
  }
}
