// lib/models/prayer_times.dart

class PrayerTime {
  final String nameAr;
  final String nameEn;
  final String key;
  final int hour;
  final int minute;

  PrayerTime({
    required this.nameAr,
    required this.nameEn,
    required this.key,
    required this.hour,
    required this.minute,
  });

  String get formatted {
    int h = hour % 12;
    if (h == 0) h = 12;
    return '${h.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  int get totalMinutes => hour * 60 + minute;
}

class PrayerTimesModel {
  final PrayerTime fajr;
  final PrayerTime sunrise;
  final PrayerTime dhuhr;
  final PrayerTime asr;
  final PrayerTime maghrib;
  final PrayerTime isha;

  PrayerTimesModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  List<PrayerTime> get all => [fajr, sunrise, dhuhr, asr, maghrib, isha];

  PrayerTime? getNextPrayer() {
    final now = DateTime.now();
    final nowMin = now.hour * 60 + now.minute;
    for (final p in all) {
      if (nowMin < p.totalMinutes) return p;
    }
    return fajr; // بعد العشاء → الفجر
  }

  String getTimeLeft() {
    final now = DateTime.now();
    final nowMin = now.hour * 60 + now.minute;
    final next = getNextPrayer();
    if (next == null) return '--';

    int diff = next.totalMinutes - nowMin;
    if (diff < 0) diff += 24 * 60;

    final h = diff ~/ 60;
    final m = diff % 60;
    int displayH = h % 12;
    if (displayH == 0) displayH = 12;
    return '${displayH.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}

class WeatherData {
  final String temp;
  final String condition;

  WeatherData({required this.temp, required this.condition});

  factory WeatherData.empty() => WeatherData(temp: '--', condition: '---');
}

class HijriDateModel {
  final int day;
  final int month;
  final int year;
  final String monthName;
  final String weekDayAr;

  HijriDateModel({
    required this.day,
    required this.month,
    required this.year,
    required this.monthName,
    required this.weekDayAr,
  });
}
