import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PercentageSelectorWidget extends StatelessWidget {
  final double selectedPercentage;
  final Function(double) onPercentageChanged;

  const PercentageSelectorWidget({
    super.key,
    required this.selectedPercentage,
    required this.onPercentageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Concentration Percentage',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildPercentageOption(2.0),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildPercentageOption(4.0),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              selectedPercentage == 2.0
                  ? '2% concentration is recommended for most mushroom species'
                  : '4% concentration provides stronger nutrient density for demanding cultures',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentageOption(double percentage) {
    final isSelected = selectedPercentage == percentage;

    return GestureDetector(
      onTap: () => onPercentageChanged(percentage),
      child: Container(
        height: 6.h,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: isSelected
                      ? 'radio_button_checked'
                      : 'radio_button_unchecked',
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  '${percentage.toInt()}%',
                  style: AppTheme.getDataTextStyle(
                    isLight: true,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ).copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Text(
              percentage == 2.0 ? 'Standard' : 'Strong',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                        .withValues(alpha: 0.8)
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
