// lib/services/weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prayer_times.dart';

class WeatherService {
  static Future<WeatherData> fetchWeather(double lat, double lng) async {
    try {
      final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$lat&longitude=$lng'
        '&current=temperature_2m,weathercode&timezone=auto',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final temp = data['current']['temperature_2m'].round();
        final code = data['current']['weathercode'] as int;
        final condition = _getCondition(code);
        return WeatherData(temp: '$temp°', condition: condition);
      }
    } catch (_) {}
    return WeatherData.empty();
  }

  static String _getCondition(int code) {
    if (code == 0) return 'صحو';
    if (code <= 3) return 'غائم جزئياً';
    if (code <= 48) return 'ضبابي';
    if (code <= 67) return 'ممطر';
    if (code <= 77) return 'ثلوج';
    if (code <= 82) return 'زخات مطر';
    if (code <= 99) return 'عاصف';
    return 'صحو';
  }
}
