import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class CalculationCardWidget extends StatelessWidget {
  final Map<String, dynamic> calculation;
  final Function(String, Map<String, dynamic>) onAction;

  const CalculationCardWidget({
    super.key,
    required this.calculation,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Dismissible(
        key: Key(calculation["id"].toString()),
        background: _buildSwipeBackground(isLeft: true),
        secondaryBackground: _buildSwipeBackground(isLeft: false),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            _showQuickActions(context);
          } else {
            onAction('delete', calculation);
          }
        },
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            _showQuickActions(context);
            return false;
          }
          return true;
        },
        child: GestureDetector(
          onTap: () => onAction('view', calculation),
          onLongPress: () => _showContextMenu(context),
          child: Card(
            elevation: AppTheme.lightTheme.cardTheme.elevation,
            shape: AppTheme.lightTheme.cardTheme.shape,
            margin: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: calculation["type"] == "CVG"
                              ? AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1)
                              : AppTheme.lightTheme.colorScheme.secondary
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          calculation["type"] as String,
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: calculation["type"] == "CVG"
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        calculation["timestamp"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _buildInputSummary(),
                  SizedBox(height: 1.5.h),
                  _buildResultsSummary(),
                  if (calculation["notes"] != null &&
                      (calculation["notes"] as String).isNotEmpty) ...[
                    SizedBox(height: 1.5.h),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'note',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              calculation["notes"] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'more_horiz' : 'delete',
                color: isLeft
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeft ? 'Actions' : 'Delete',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: isLeft
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSummary() {
    final inputs = calculation["inputs"] as Map<String, dynamic>;
    final type = calculation["type"] as String;

    if (type == "CVG") {
      final cocoCoir = inputs["cocoCoir"] as double;
      return Row(
        children: [
          CustomIconWidget(
            iconName: 'input',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            'Input: ',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            '${cocoCoir.toStringAsFixed(0)}g Coco Coir',
            style: AppTheme.getDataTextStyle(
              isLight: true,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    } else {
      final water = inputs["water"] as double;
      final ingredient = inputs["ingredient"] as String;
      final percentage = inputs["percentage"] as int;
      return Row(
        children: [
          CustomIconWidget(
            iconName: 'input',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            'Input: ',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            '${water.toStringAsFixed(0)}ml Water, $percentage% $ingredient',
            style: AppTheme.getDataTextStyle(
              isLight: true,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildResultsSummary() {
    final results = calculation["results"] as Map<String, dynamic>;
    final type = calculation["type"] as String;

    if (type == "CVG") {
      final water = results["water"] as double;
      final gypsum = results["gypsum"] as double;
      final vermiculite = results["vermiculite"] as double;

      return Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'science',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Results: ',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildResultItem('Water', '${water.toStringAsFixed(0)}ml'),
              _buildResultItem('Gypsum', '${gypsum.toStringAsFixed(1)}g'),
              _buildResultItem(
                  'Vermiculite', '${vermiculite.toStringAsFixed(0)}ml'),
            ],
          ),
        ],
      );
    } else {
      final water = results["water"] as double;
      final ingredientAmount =
          results.values.firstWhere((value) => value != water) as double;
      final ingredientName = results.keys.firstWhere((key) => key != "water");

      return Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'science',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Results: ',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildResultItem('Water', '${water.toStringAsFixed(0)}ml'),
              _buildResultItem(
                  ingredientName == "maltExtract" ? "Malt Extract" : "Honey",
                  '${ingredientAmount.toStringAsFixed(1)}g'),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildResultItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.getDataTextStyle(
            isLight: true,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context,
                  'View Details',
                  'visibility',
                  () => onAction('view', calculation),
                ),
                _buildActionButton(
                  context,
                  'Recalculate',
                  'refresh',
                  () => onAction('recalculate', calculation),
                ),
                _buildActionButton(
                  context,
                  'Share',
                  'share',
                  () => onAction('share', calculation),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'More Options',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            _buildMenuOption(
              context,
              'View Details',
              'visibility',
              () => onAction('view', calculation),
            ),
            _buildMenuOption(
              context,
              'Recalculate',
              'refresh',
              () => onAction('recalculate', calculation),
            ),
            _buildMenuOption(
              context,
              'Duplicate',
              'content_copy',
              () => onAction('duplicate', calculation),
            ),
            _buildMenuOption(
              context,
              'Share',
              'share',
              () => onAction('share', calculation),
            ),
            _buildMenuOption(
              context,
              'Export',
              'download',
              () => onAction('export', calculation),
            ),
            Divider(height: 3.h),
            _buildMenuOption(
              context,
              'Delete',
              'delete',
              () => onAction('delete', calculation),
              isDestructive: true,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    String iconName,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context,
    String label,
    String iconName,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: isDestructive
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        label,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: isDestructive
              ? AppTheme.lightTheme.colorScheme.error
              : AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
