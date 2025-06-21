import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/language_picker_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isMetricUnits = true;
  bool _isHoneyDefault = true;
  int _decimalPrecision = 2;
  String _currentLanguage = 'English';
  bool _autoCleanupEnabled = false;
  int _cleanupDays = 30;

  final List<Map<String, dynamic>> _supportedLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español'},
    {'code': 'fr', 'name': 'French', 'nativeName': 'Français'},
    {'code': 'de', 'name': 'German', 'nativeName': 'Deutsch'},
    {'code': 'it', 'name': 'Italian', 'nativeName': 'Italiano'},
    {'code': 'pt', 'name': 'Portuguese', 'nativeName': 'Português'},
    {'code': 'ru', 'name': 'Russian', 'nativeName': 'Русский'},
    {'code': 'ja', 'name': 'Japanese', 'nativeName': '日本語'},
    {'code': 'ko', 'name': 'Korean', 'nativeName': '한국어'},
    {'code': 'zh', 'name': 'Chinese', 'nativeName': '中文'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isMetricUnits = prefs.getBool('metric_units') ?? true;
      _isHoneyDefault = prefs.getBool('honey_default') ?? true;
      _decimalPrecision = prefs.getInt('decimal_precision') ?? 2;
      _currentLanguage = prefs.getString('current_language') ?? 'English';
      _autoCleanupEnabled = prefs.getBool('auto_cleanup') ?? false;
      _cleanupDays = prefs.getInt('cleanup_days') ?? 30;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('metric_units', _isMetricUnits);
    await prefs.setBool('honey_default', _isHoneyDefault);
    await prefs.setInt('decimal_precision', _decimalPrecision);
    await prefs.setString('current_language', _currentLanguage);
    await prefs.setBool('auto_cleanup', _autoCleanupEnabled);
    await prefs.setInt('cleanup_days', _cleanupDays);
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LanguagePickerWidget(
        supportedLanguages: _supportedLanguages,
        currentLanguage: _currentLanguage,
        onLanguageSelected: (language) {
          setState(() {
            _currentLanguage = language;
          });
          _saveSettings();
        },
      ),
    );
  }

  void _showDecimalPrecisionPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 40.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Decimal Precision',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  final precision = index;
                  return ListTile(
                    title: Text(
                      '\$precision decimal places',
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      'Example: ${(123.456789).toStringAsFixed(precision)}',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    trailing: _decimalPrecision == precision
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _decimalPrecision = precision;
                      });
                      _saveSettings();
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCleanupDaysPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 40.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Auto Cleanup Period',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView(
                children: [7, 14, 30, 60, 90, 180].map((days) {
                  return ListTile(
                    title: Text(
                      '\$days days',
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      days == 7
                          ? 'Weekly cleanup'
                          : days == 14
                              ? 'Bi-weekly cleanup'
                              : days == 30
                                  ? 'Monthly cleanup'
                                  : days == 60
                                      ? 'Bi-monthly cleanup'
                                      : days == 90
                                          ? 'Quarterly cleanup'
                                          : 'Semi-annual cleanup',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    trailing: _cleanupDays == days
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _cleanupDays = days;
                      });
                      _saveSettings();
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear History',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to clear all calculation history? This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('calculation_history');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calculation history cleared'),
                  backgroundColor: AppTheme.getSuccessColor(true),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
            ),
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reset All Settings',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'This will reset all app settings to their default values. Your calculation history will not be affected.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              setState(() {
                _isMetricUnits = true;
                _isHoneyDefault = true;
                _decimalPrecision = 2;
                _currentLanguage = 'English';
                _autoCleanupEnabled = false;
                _cleanupDays = 30;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Settings reset to defaults'),
                  backgroundColor: AppTheme.getSuccessColor(true),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
            ),
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _exportData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyData = prefs.getString('calculation_history') ?? '[]';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export functionality would be implemented here'),
          backgroundColor: AppTheme.getWarningColor(true),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: \${e.toString()}'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Done',
              style: TextStyle(
                color: AppTheme.lightTheme.appBarTheme.foregroundColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Section
            SettingsSectionWidget(
              title: 'Language & Region',
              children: [
                SettingsItemWidget(
                  title: 'Language',
                  subtitle: _currentLanguage,
                  leadingIcon: 'language',
                  trailingIcon: 'chevron_right',
                  onTap: _showLanguagePicker,
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Units Section
            SettingsSectionWidget(
              title: 'Units & Measurements',
              children: [
                SettingsItemWidget(
                  title: 'Measurement Units',
                  subtitle: _isMetricUnits
                      ? 'Metric (g, ml)'
                      : 'Imperial (oz, fl oz)',
                  leadingIcon: 'straighten',
                  trailing: Switch(
                    value: _isMetricUnits,
                    onChanged: (value) {
                      setState(() {
                        _isMetricUnits = value;
                      });
                      _saveSettings();
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Calculation Preferences Section
            SettingsSectionWidget(
              title: 'Calculation Preferences',
              children: [
                SettingsItemWidget(
                  title: 'Default LC Ingredient',
                  subtitle: _isHoneyDefault ? 'Honey' : 'Malt Extract',
                  leadingIcon: 'science',
                  trailing: Switch(
                    value: _isHoneyDefault,
                    onChanged: (value) {
                      setState(() {
                        _isHoneyDefault = value;
                      });
                      _saveSettings();
                    },
                  ),
                ),
                SettingsItemWidget(
                  title: 'Decimal Precision',
                  subtitle: '\$_decimalPrecision decimal places',
                  leadingIcon: 'decimal_increase',
                  trailingIcon: 'chevron_right',
                  onTap: _showDecimalPrecisionPicker,
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // History Section
            SettingsSectionWidget(
              title: 'History & Data',
              children: [
                SettingsItemWidget(
                  title: 'Export Data',
                  subtitle: 'Export all calculations',
                  leadingIcon: 'file_download',
                  trailingIcon: 'chevron_right',
                  onTap: _exportData,
                ),
                SettingsItemWidget(
                  title: 'Clear History',
                  subtitle: 'Remove all saved calculations',
                  leadingIcon: 'delete_sweep',
                  trailingIcon: 'chevron_right',
                  onTap: _showClearHistoryDialog,
                ),
                SettingsItemWidget(
                  title: 'Auto Cleanup',
                  subtitle: _autoCleanupEnabled
                      ? 'Clean after \$_cleanupDays days'
                      : 'Disabled',
                  leadingIcon: 'auto_delete',
                  trailing: Switch(
                    value: _autoCleanupEnabled,
                    onChanged: (value) {
                      setState(() {
                        _autoCleanupEnabled = value;
                      });
                      _saveSettings();
                    },
                  ),
                ),
                if (_autoCleanupEnabled)
                  SettingsItemWidget(
                    title: 'Cleanup Period',
                    subtitle: '\$_cleanupDays days',
                    leadingIcon: 'schedule',
                    trailingIcon: 'chevron_right',
                    onTap: _showCleanupDaysPicker,
                    isIndented: true,
                  ),
              ],
            ),

            SizedBox(height: 2.h),

            // About Section
            SettingsSectionWidget(
              title: 'About',
              children: [
                SettingsItemWidget(
                  title: 'App Version',
                  subtitle: '1.0.0 (Build 1)',
                  leadingIcon: 'info',
                ),
                SettingsItemWidget(
                  title: 'Developer',
                  subtitle: 'FungiNautas Team',
                  leadingIcon: 'code',
                ),
                SettingsItemWidget(
                  title: 'Support',
                  subtitle: 'Get help and report issues',
                  leadingIcon: 'help',
                  trailingIcon: 'open_in_new',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Support page would open here'),
                        backgroundColor: AppTheme.getWarningColor(true),
                      ),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Privacy Section
            SettingsSectionWidget(
              title: 'Privacy & Security',
              children: [
                SettingsItemWidget(
                  title: 'Data Handling',
                  subtitle: 'All data stored locally',
                  leadingIcon: 'privacy_tip',
                ),
                SettingsItemWidget(
                  title: 'Reset All Settings',
                  subtitle: 'Restore default preferences',
                  leadingIcon: 'restore',
                  trailingIcon: 'chevron_right',
                  onTap: _showResetDialog,
                ),
              ],
            ),

            SizedBox(height: 4.h),

            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    'FungiNautas Calculator',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Precision cultivation made simple',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
