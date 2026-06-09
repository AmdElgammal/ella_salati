// lib/models/settings.dart

class AppSettings {
  String city;
  double lat;
  double lng;
  String method; // 'UQU' | 'MWL' | 'Egypt'
  Map<String, int> offsets;

  AppSettings({
    this.city = 'الكويت',
    this.lat = 29.3759,
    this.lng = 47.9774,
    this.method = 'UQU',
    Map<String, int>? offsets,
  }) : offsets = offsets ??
            {
              'fajr': 0,
              'dhuhr': 0,
              'asr': 0,
              'maghrib': 0,
              'isha': 0,
            };

  Map<String, dynamic> toJson() => {
        'city': city,
        'lat': lat,
        'lng': lng,
        'method': method,
        'offsets': offsets,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        city: json['city'] ?? 'الكويت',
        lat: (json['lat'] ?? 29.3759).toDouble(),
        lng: (json['lng'] ?? 47.9774).toDouble(),
        method: json['method'] ?? 'UQU',
        offsets: json['offsets'] != null
            ? Map<String, int>.from(json['offsets'])
            : null,
      );

  // كل المدن المدعومة
  static Map<String, Map<String, double>> cities = {
    'الكويت': {'lat': 29.3759, 'lng': 47.9774},
    'مكة المكرمة': {'lat': 21.4225, 'lng': 39.8262},
    'المدينة المنورة': {'lat': 24.5247, 'lng': 39.5692},
    'الرياض': {'lat': 24.7136, 'lng': 46.6753},
    'جدة': {'lat': 21.5433, 'lng': 39.1728},
    'القاهرة': {'lat': 30.0444, 'lng': 31.2357},
    'دبي': {'lat': 25.2048, 'lng': 55.2708},
    'أبوظبي': {'lat': 24.4539, 'lng': 54.3773},
    'عمّان': {'lat': 31.9454, 'lng': 35.9284},
    'بيروت': {'lat': 33.8938, 'lng': 35.5018},
    'بغداد': {'lat': 33.3152, 'lng': 44.3661},
    'دمشق': {'lat': 33.5138, 'lng': 36.2765},
    'تونس': {'lat': 36.8190, 'lng': 10.1658},
    'الدوحة': {'lat': 25.2854, 'lng': 51.5310},
    'المنامة': {'lat': 26.2154, 'lng': 50.5832},
    'مسقط': {'lat': 23.5880, 'lng': 58.3829},
    'الخرطوم': {'lat': 15.5518, 'lng': 32.5324},
  };
}
