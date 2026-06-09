// lib/screens/home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/responsive.dart';
import '../models/prayer_times.dart';
import '../models/settings.dart';
import '../services/prayer_service.dart';
import '../services/hijri_service.dart';
import '../services/weather_service.dart';
import '../services/settings_service.dart';
import '../services/adhan_service.dart';
import '../widgets/clock_widget.dart';
import '../widgets/prayer_table_widget.dart';
import '../widgets/bottom_cards_widget.dart';
import '../widgets/settings_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppSettings _settings = AppSettings();
  PrayerTimesModel? _prayerTimes;
  HijriDateModel? _hijri;
  WeatherData _weather = WeatherData.empty();

  Timer? _clockTimer;
  Timer? _dataTimer;
  Timer? _adhanTimer;

  @override
  void initState() {
    super.initState();
    _loadAndRefresh();

    // الساعة تتحدث كل ثانية
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });

    // تحديث البيانات كل دقيقة
    _dataTimer = Timer.periodic(const Duration(minutes: 1), (_) => _refresh());

    // فحص الأذان كل ثانية
    _adhanTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_prayerTimes != null) _checkAdhan();
    });
  }

  Future<void> _loadAndRefresh() async {
    _settings = await SettingsService.load();
    await _refresh();
  }

  Future<void> _refresh() async {
    final now = DateTime.now();
    final times = PrayerService.calculate(_settings, date: now);
    final hijri = await HijriService.getHijriDate(now);
    final weather =
        await WeatherService.fetchWeather(_settings.lat, _settings.lng);
    if (mounted) {
      setState(() {
        _prayerTimes = times;
        _hijri = hijri;
        _weather = weather;
      });
    }
  }

  void _checkAdhan() {
    if (_prayerTimes == null) return;
    final times = {
      for (final p in _prayerTimes!.all) p.key: (h: p.hour, m: p.minute),
    };
    AdhanService.checkAndPlay(times, DateTime.now());
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SettingsSheet(
        settings: _settings,
        onSave: (newSettings) async {
          _settings = newSettings;
          await SettingsService.save(_settings);
          await _refresh();
        },
      ),
    );
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _dataTimer?.cancel();
    _adhanTimer?.cancel();
    AdhanService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = getScale(context);
    final isLarge = isLargeScreen(context);

    // عرض البطاقة الرئيسية: نحدده نسبياً
    final cardMaxWidth = isLarge ? 900.0 : 680.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: cardMaxWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16 * scale),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(32 * scale),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.15 * 255).round()),
                      blurRadius: 35,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(18 * scale),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ===== العنوان الرئيسي =====
                    _buildHeader(scale),
                    SizedBox(height: 12 * scale),

                    // ===== التاريخ =====
                    _buildDateRow(scale),
                    SizedBox(height: 12 * scale),

                    // ===== الساعة =====
                    ClockWidget(),
                    SizedBox(height: 14 * scale),

                    // ===== جدول الصلوات =====
                    if (_prayerTimes != null)
                      PrayerTableWidget(prayerTimes: _prayerTimes!)
                    else
                      _buildLoadingTable(scale),
                    SizedBox(height: 18 * scale),

                    // ===== الكروت السفلية =====
                    if (_prayerTimes != null)
                      BottomCardsWidget(
                        prayerTimes: _prayerTimes!,
                        weather: _weather,
                      )
                    else
                      _buildLoadingCards(scale),
                    SizedBox(height: 16 * scale),

                    // ===== الدعاء =====
                    _buildFooter(scale),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== العنوان مع أيقونة الإعدادات =====
  Widget _buildHeader(double scale) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Text('🕌', style: TextStyle(fontSize: 48 * scale)),
            SizedBox(height: 4 * scale),
            Text('إلا صلاتي', style: AppTextStyles.title(scale)),
            Text('My Prayer is My Life', style: AppTextStyles.subtitle(scale)),
          ],
        ),
        // زر الإعدادات في الزاوية
        Positioned(
          left: 0,
          top: 0,
          child: GestureDetector(
            onTap: _openSettings,
            child: Container(
              padding: EdgeInsets.all(8 * scale),
              decoration: BoxDecoration(
                color: AppColors.darkCard.withAlpha((0.6 * 255).round()),
                borderRadius: BorderRadius.circular(12 * scale),
              ),
              child: Text('⚙️', style: TextStyle(fontSize: 18 * scale)),
            ),
          ),
        ),
      ],
    );
  }

  // ===== شريط التاريخ =====
  Widget _buildDateRow(double scale) {
    final now = DateTime.now();
    const monthsEn = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const daysAr = [
      'الأحد',
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت'
    ];
    final gregStr = '${now.day} ${monthsEn[now.month - 1]} ${now.year}';
    final weekday = daysAr[now.weekday % 7];

    String hijriStr = '--';
    if (_hijri != null) {
      hijriStr = '${_hijri!.day} ${_hijri!.monthName} ${_hijri!.year}';
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16 * scale,
        vertical: 6 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha((0.07 * 255).round()),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            Text('📅', style: TextStyle(fontSize: 14 * scale)),
            Text(gregStr, style: AppTextStyles.dateText(scale)),
            Text('|',
                style: AppTextStyles.dateText(scale)
                    .copyWith(color: AppColors.separator)),
            Text(hijriStr, style: AppTextStyles.dateText(scale)),
            Text('|',
                style: AppTextStyles.dateText(scale)
                    .copyWith(color: AppColors.separator)),
            Text(weekday, style: AppTextStyles.dateText(scale)),
          ],
        ),
      ),
    );
  }

  // ===== مؤشر التحميل للجدول =====
  Widget _buildLoadingTable(double scale) {
    return Container(
      height: 240 * scale,
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(24 * scale),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.goldText),
      ),
    );
  }

  Widget _buildLoadingCards(double scale) {
    return SizedBox(
      height: 90 * scale,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.goldText),
      ),
    );
  }

  // ===== الدعاء =====
  Widget _buildFooter(double scale) {
    return Container(
      padding: EdgeInsets.only(top: 12 * scale),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1.5),
        ),
      ),
      child: Column(
        children: [
          Text(
            'تقبل الله منا ومنكم صالح الأعمال',
            style: AppTextStyles.footerDua(scale),
            textAlign: TextAlign.center,
          ),
          Text(
            'May Allah accept our good deeds from us and from you',
            style: AppTextStyles.footerDuaEn(scale),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
