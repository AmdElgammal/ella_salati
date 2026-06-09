// lib/services/adhan_service.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AdhanService {
  static final AudioPlayer _player = AudioPlayer();
  static final Set<String> _triggered = {};

  /// يُشغَّل كل ثانية من Timer في الشاشة الرئيسية
  static Future<void> checkAndPlay(
    Map<String, ({int h, int m})> times,
    DateTime now,
  ) async {
    final nowMin = now.hour * 60 + now.minute;

    for (final entry in times.entries) {
      final key = '${now.toIso8601String().substring(0, 10)}_${entry.key}';
      final pMin = entry.value.h * 60 + entry.value.m;

      if ((nowMin - pMin).abs() <= 1 && !_triggered.contains(key)) {
        _triggered.add(key);
        await _playAdhan();
        await _vibrate();
      }
    }
  }

  static Future<void> _playAdhan() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('adhan.mp3'));
    } catch (_) {}
  }

  static Future<void> _vibrate() async {
    try {
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 200));
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  static void dispose() {
    _player.dispose();
  }
}
