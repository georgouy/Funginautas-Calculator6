import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onStartCalculation;

  const EmptyStateWidget({
    super.key,
    required this.onStartCalculation,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration container
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circles for depth
                  Positioned(
                    top: 8.w,
                    left: 8.w,
                    child: Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10.w,
                    right: 6.w,
                    child: Container(
                      width: 4.w,
                      height: 4.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),
                  ),
                  // Main calculator icon
                  CustomIconWidget(
                    iconName: 'calculate',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 64,
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),

            // Main heading
            Text(
              'No Calculations Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),

            // Description text
            Text(
              'Start your mushroom cultivation journey by creating your first substrate or liquid culture calculation.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),

            // Feature highlights
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  _buildFeatureItem(
                    'science',
                    'CVG Substrate Calculator',
                    'Calculate precise ratios for coco coir, vermiculite, and gypsum',
                  ),
                  SizedBox(height: 2.h),
                  _buildFeatureItem(
                    'biotech',
                    'LC Broth Calculator',
                    'Prepare liquid culture with malt extract or honey solutions',
                  ),
                  SizedBox(height: 2.h),
                  _buildFeatureItem(
                    'history',
                    'Track Your Progress',
                    'Save and review all your calculations for future reference',
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),

            // Call to action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onStartCalculation,
                style: AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'add_circle',
                      color: AppTheme.lightTheme.elevatedButtonTheme.style
                              ?.foregroundColor
                              ?.resolve({}) ??
                          Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Start Your First Calculation',
                      style: AppTheme
                          .lightTheme.elevatedButtonTheme.style?.textStyle
                          ?.resolve({})?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Secondary action
            TextButton(
              onPressed: () {
                // Show tips or help
                _showCalculationTips(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'help_outline',
                    color: AppTheme
                            .lightTheme.textButtonTheme.style?.foregroundColor
                            ?.resolve({}) ??
                        AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Calculation Tips',
                    style: AppTheme.lightTheme.textButtonTheme.style?.textStyle
                        ?.resolve({}),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String iconName, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(5.w),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCalculationTips(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'lightbulb',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Calculation Tips',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildTipCard(
                      'CVG Substrate Ratios',
                      'The standard CVG (Coco Coir, Vermiculite, Gypsum) ratio is:\n• Coco Coir: Base amount\n• Water: 2.5x coco coir weight\n• Gypsum: 5% of coco coir weight\n• Vermiculite: Equal to coco coir volume',
                      'science',
                    ),
                    SizedBox(height: 2.h),
                    _buildTipCard(
                      'LC Broth Concentrations',
                      'Liquid Culture nutrient concentrations:\n• 2% solution: Standard for most species\n• 4% solution: For aggressive growth\n• Malt Extract: Traditional choice\n• Honey: Natural alternative with antimicrobial properties',
                      'biotech',
                    ),
                    SizedBox(height: 2.h),
                    _buildTipCard(
                      'Best Practices',
                      '• Always sterilize your substrate and LC broth\n• Use distilled water for consistent results\n• Store calculations for future reference\n• Scale recipes based on your container sizes\n• Monitor pH levels for optimal growth',
                      'verified',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String content, String iconName) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            content,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
