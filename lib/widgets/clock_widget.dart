// lib/widgets/clock_widget.dart
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/responsive.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({super.key});

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkCtrl;
  late Animation<double> _blinkAnim;

  @override
  void initState() {
    super.initState();
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _blinkAnim = Tween<double>(begin: 1.0, end: 0.2).animate(
      CurvedAnimation(parent: _blinkCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _blinkCtrl.dispose();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final scale = getScale(context);
    final now = DateTime.now();
    int h = now.hour % 12;
    if (h == 0) h = 12;
    final m = now.minute;
    final ampm = now.hour >= 12 ? 'م' : 'ص';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(28 * scale),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 6 * scale,
        horizontal: 16 * scale,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'الوقت الحالي - Current Time',
            style: AppTextStyles.clockLabel(scale),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // الدقائق (RTL: تُعرض أولاً على اليسار)
              Text(_pad(m), style: AppTextStyles.clockDigits(scale)),
              // النقطتان الومّاضتان
              AnimatedBuilder(
                animation: _blinkAnim,
                builder: (_, __) => Opacity(
                  opacity: _blinkAnim.value,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4 * scale),
                    child: Text(
                      ':',
                      style: AppTextStyles.clockDigits(scale),
                    ),
                  ),
                ),
              ),
              // الساعة
              Text(_pad(h), style: AppTextStyles.clockDigits(scale)),
              // ص/م
              Padding(
                padding: EdgeInsets.only(right: 8 * scale),
                child: Text(
                  ampm,
                  style: TextStyle(
                    fontSize: 18 * scale,
                    color: AppColors.ampmColor,
                    fontFamily: 'NotoNaskhArabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
