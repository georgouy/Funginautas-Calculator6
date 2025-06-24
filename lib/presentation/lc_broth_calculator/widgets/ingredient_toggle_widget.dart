import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IngredientToggleWidget extends StatelessWidget {
  final String selectedIngredient;
  final Function(String) onIngredientChanged;

  const IngredientToggleWidget({
    super.key,
    required this.selectedIngredient,
    required this.onIngredientChanged,
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
              AppLocalizations.translate("ingredientSelection"),
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildIngredientOption(
                      AppLocalizations.translate("maltExtract"),
                      AppLocalizations.translate("maltExtract"), // Usar a string traduzida como identificador
                      'science',
                      selectedIngredient == AppLocalizations.translate("maltExtract"),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 6.h,
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                  Expanded(
                    child: _buildIngredientOption(
                      AppLocalizations.translate("honey"),
                      AppLocalizations.translate("honey"), // Usar a string traduzida como identificador
                      'local_florist',
                      selectedIngredient == AppLocalizations.translate("honey"),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              selectedIngredient == AppLocalizations.translate("honey")
                  ? AppLocalizations.translate("honeyDescription")
                  : AppLocalizations.translate("maltExtractDescription"),
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientOption(
      String displayIngredient, String identifierIngredient, String iconName, bool isSelected) {
    return GestureDetector(
      onTap: () => onIngredientChanged(identifierIngredient),
      child: Container(
        height: 6.h,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.onPrimary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              displayIngredient,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


