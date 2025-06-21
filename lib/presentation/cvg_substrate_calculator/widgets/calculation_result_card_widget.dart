import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CalculationResultCardWidget extends StatelessWidget {
  final double cocoCoirAmount;
  final double waterAmount;
  final double gypsumAmount;
  final double vermiculiteAmount;

  const CalculationResultCardWidget({
    super.key,
    required this.cocoCoirAmount,
    required this.waterAmount,
    required this.gypsumAmount,
    required this.vermiculiteAmount,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.getSuccessColor(isLight).withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.getSuccessColor(isLight).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.getSuccessColor(isLight),
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Recipe Ready',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.getSuccessColor(isLight),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Results grid
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildResultItem(
                      context: context,
                      icon: 'grass',
                      label: 'Coco Coir',
                      amount: cocoCoirAmount,
                      unit: 'g',
                      color: const Color(0xFF8B4513),
                      isLight: isLight,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: _buildResultItem(
                      context: context,
                      icon: 'water_drop',
                      label: 'Water',
                      amount: waterAmount,
                      unit: 'ml',
                      color: const Color(0xFF2196F3),
                      isLight: isLight,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.w),
              Row(
                children: [
                  Expanded(
                    child: _buildResultItem(
                      context: context,
                      icon: 'scatter_plot',
                      label: 'Gypsum',
                      amount: gypsumAmount,
                      unit: 'g',
                      color: const Color(0xFFE0E0E0),
                      isLight: isLight,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: _buildResultItem(
                      context: context,
                      icon: 'grain',
                      label: 'Vermiculite',
                      amount: vermiculiteAmount,
                      unit: 'ml',
                      color: const Color(0xFFD4AF37),
                      isLight: isLight,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Total volume info
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Substrate Volume',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      Text(
                        'Approximately ${((cocoCoirAmount + vermiculiteAmount) * 1.5).toStringAsFixed(0)}ml when hydrated',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isLight
                                  ? AppTheme.textSecondaryLight
                                  : AppTheme.textSecondaryDark,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem({
    required BuildContext context,
    required String icon,
    required String label,
    required double amount,
    required String unit,
    required Color color,
    required bool isLight,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isLight
                      ? AppTheme.textSecondaryLight
                      : AppTheme.textSecondaryDark,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: amount.toStringAsFixed(amount % 1 == 0 ? 0 : 1),
                  style: AppTheme.getDataTextStyle(
                    isLight: isLight,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isLight
                            ? AppTheme.textSecondaryLight
                            : AppTheme.textSecondaryDark,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
