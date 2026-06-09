// lib/services/hijri_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hijri/hijri_calendar.dart';
import '../models/prayer_times.dart';

const List<String> _monthsAr = [
  'محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر',
  'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
  'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة',
];

const List<String> _daysAr = [
  'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء',
  'الخميس', 'الجمعة', 'السبت',
];

class HijriService {
  // محاولة الجلب من API ثم Fallback محلي
  static Future<HijriDateModel> getHijriDate(DateTime date) async {
    try {
      final d = date.day;
      final m = date.month;
      final y = date.year;
      final uri = Uri.parse('https://api.aladhan.com/v1/gToH/$d-$m-$y');
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == 200) {
          final h = data['data']['hijri'];
          return HijriDateModel(
            day: int.parse(h['day']),
            month: int.parse(h['month']['number'].toString()),
            year: int.parse(h['year']),
            monthName: h['month']['ar'],
            weekDayAr: h['weekday']['ar'],
          );
        }
      }
    } catch (_) {}
    return _localHijri(date);
  }

  // حساب محلي باستخدام حزمة hijri
  static HijriDateModel _localHijri(DateTime date) {
    final h = HijriCalendar.fromDate(date);
    return HijriDateModel(
      day: h.hDay,
      month: h.hMonth,
      year: h.hYear,
      monthName: _monthsAr[h.hMonth - 1],
      weekDayAr: _daysAr[date.weekday % 7],
    );
  }
}
