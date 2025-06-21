import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CalculationResultsWidget extends StatelessWidget {
  final Map<String, dynamic> results;
  final VoidCallback onSaveToHistory;
  final VoidCallback onShare;

  const CalculationResultsWidget({
    super.key,
    required this.results,
    required this.onSaveToHistory,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
              AppTheme.lightTheme.colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'science',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'LC Broth Recipe',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // Results Grid
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    _buildResultRow(
                      'Water',
                      '${results['waterAmount'].toStringAsFixed(1)} ml',
                      'water_drop',
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                    Divider(height: 2.h),
                    _buildResultRow(
                      results['ingredientType'] as String,
                      '${results['ingredientAmount'].toStringAsFixed(2)} g',
                      results['ingredientType'] == 'Honey'
                          ? 'local_florist'
                          : 'science',
                      AppTheme.getAccentColor(true),
                    ),
                    Divider(height: 2.h),
                    _buildResultRow(
                      'Concentration',
                      '${results['percentage'].toStringAsFixed(1)}%',
                      'percent',
                      AppTheme.getSuccessColor(true),
                    ),
                    Divider(height: 2.h),
                    _buildResultRow(
                      'Total Volume',
                      '${results['totalVolume'].toStringAsFixed(1)} ml',
                      'science',
                      AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // Instructions
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        AppTheme.getSuccessColor(true).withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: AppTheme.getSuccessColor(true),
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Preparation Instructions',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.getSuccessColor(true),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '1. Heat water to 60-70°C (140-158°F)\n'
                      '2. Dissolve ${results['ingredientAmount'].toStringAsFixed(2)}g of ${results['ingredientType'].toString().toLowerCase()} completely\n'
                      '3. Allow to cool to room temperature\n'
                      '4. Sterilize in pressure cooker for 15 minutes at 15 PSI\n'
                      '5. Cool and inoculate under sterile conditions',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.getSuccessColor(true)
                            .withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onSaveToHistory,
                      icon: CustomIconWidget(
                        iconName: 'bookmark_add',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 18,
                      ),
                      label: Text('Save to History'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onShare,
                      icon: CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 18,
                      ),
                      label: Text('Share Recipe'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(
      String label, String value, String iconName, Color color) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: AppTheme.getDataTextStyle(
            isLight: true,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ).copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}
