// lib/widgets/settings_sheet.dart
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/responsive.dart';
import '../models/settings.dart';

class SettingsSheet extends StatefulWidget {
  final AppSettings settings;
  final void Function(AppSettings) onSave;

  const SettingsSheet({
    super.key,
    required this.settings,
    required this.onSave,
  });

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  late String _city;
  late String _method;
  late Map<String, int> _offsets;
  late TextEditingController _cityCtrl;

  @override
  void initState() {
    super.initState();
    _city = widget.settings.city;
    _method = widget.settings.method;
    _offsets = Map.from(widget.settings.offsets);
    _cityCtrl = TextEditingController(text: _city);
  }

  @override
  void dispose() {
    _cityCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final updated = AppSettings(
      city: _cityCtrl.text.trim().isEmpty ? _city : _cityCtrl.text.trim(),
      method: _method,
      offsets: _offsets,
    );
    // تحديث الإحداثيات من قاموس المدن
    final cityData = AppSettings.cities[updated.city];
    if (cityData != null) {
      updated.lat = cityData['lat']!;
      updated.lng = cityData['lng']!;
    }
    widget.onSave(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final scale = getScale(context).clamp(0.9, 1.8);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.settingsBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.all(20 * scale),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // مقبض
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 16 * scale),
            Text(
              '⚙️ الإعدادات',
              style: TextStyle(
                fontSize: 20 * scale,
                color: AppColors.goldText,
                fontFamily: 'NotoNaskhArabic',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20 * scale),

            // اختيار المدينة
            _label('المدينة', scale),
            _StyledDropdown<String>(
              scale: scale,
              value: AppSettings.cities.containsKey(_city) ? _city : null,
              hint: _cityCtrl.text,
              items: AppSettings.cities.keys
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    _city = v;
                    _cityCtrl.text = v;
                  });
                }
              },
            ),
            SizedBox(height: 4 * scale),
            // أو مدينة مخصصة
            _StyledTextField(
              controller: _cityCtrl,
              hint: 'أو اكتب اسم مدينة أخرى',
              scale: scale,
            ),

            SizedBox(height: 16 * scale),
            // طريقة الحساب
            _label('طريقة الحساب', scale),
            _StyledDropdown<String>(
              scale: scale,
              value: _method,
              items: const [
                DropdownMenuItem(value: 'UQU', child: Text('أم القرى (مكة)')),
                DropdownMenuItem(value: 'MWL', child: Text('رابطة العالم الإسلامي')),
                DropdownMenuItem(value: 'Egypt', child: Text('مصر')),
              ],
              onChanged: (v) => setState(() => _method = v ?? _method),
            ),

            SizedBox(height: 16 * scale),
            _label('الإزاحات (دقائق)', scale),

            // إزاحات الصلوات
            ...(['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'].map((p) {
              final nameMap = {
                'fajr': 'الفجر', 'dhuhr': 'الظهر', 'asr': 'العصر',
                'maghrib': 'المغرب', 'isha': 'العشاء',
              };
              return Padding(
                padding: EdgeInsets.only(bottom: 8 * scale),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80 * scale,
                      child: Text(
                        nameMap[p]!,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13 * scale,
                          fontFamily: 'NotoNaskhArabic',
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(width: 12 * scale),
                    Expanded(
                      child: _StyledTextField(
                        hint: '0',
                        scale: scale,
                        initialValue: _offsets[p].toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (v) {
                          _offsets[p] = int.tryParse(v) ?? 0;
                        },
                      ),
                    ),
                  ],
                ),
              );
            })),

            SizedBox(height: 20 * scale),
            // زر الحفظ
            GestureDetector(
              onTap: _save,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14 * scale),
                decoration: BoxDecoration(
                  color: AppColors.goldText,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  'حفظ الإعدادات',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.settingsBg,
                    fontWeight: FontWeight.bold,
                    fontSize: 16 * scale,
                    fontFamily: 'NotoNaskhArabic',
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _label(String text, double scale) => Padding(
        padding: EdgeInsets.only(bottom: 6 * scale),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13 * scale,
            fontFamily: 'NotoNaskhArabic',
          ),
          textAlign: TextAlign.right,
        ),
      );
}

class _StyledDropdown<T> extends StatelessWidget {
  final T? value;
  final String? hint;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final double scale;

  const _StyledDropdown({
    required this.items,
    required this.onChanged,
    required this.scale,
    this.value,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 2 * scale),
      decoration: BoxDecoration(
        color: AppColors.settingsInput,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<T>(
        value: value,
        hint: hint != null
            ? Text(hint!, style: const TextStyle(color: Colors.white54))
            : null,
        isExpanded: true,
        dropdownColor: AppColors.settingsInput,
        underline: const SizedBox.shrink(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 14 * scale,
          fontFamily: 'NotoNaskhArabic',
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final double scale;
  final String? initialValue;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;

  const _StyledTextField({
    required this.hint,
    required this.scale,
    this.controller,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.settingsInput,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        keyboardType: keyboardType,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14 * scale,
          fontFamily: 'NotoNaskhArabic',
        ),
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 10 * scale),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
