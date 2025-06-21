import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calculator_card_widget.dart';

class CalculatorSelectorDashboard extends StatefulWidget {
  const CalculatorSelectorDashboard({super.key});

  @override
  State<CalculatorSelectorDashboard> createState() =>
      _CalculatorSelectorDashboardState();
}

class _CalculatorSelectorDashboardState
    extends State<CalculatorSelectorDashboard> {
  final List<Map<String, dynamic>> calculatorOptions = [
    {
      "id": 1,
      "title": AppLocalizations.translate("cvgCalculatorTitle"),
      "description": AppLocalizations.translate("cvgCalculatorDescription"),
      "imageUrl": "assets/images/cvg_calculator_image.jpg",
      "buttonText": AppLocalizations.translate("calculateCVG"),
      "route": "/cvg-substrate-calculator",
      "iconName": "eco",
      "color": AppTheme.primaryLight,
    },
    {
      "id": 2,
      "title": AppLocalizations.translate("lcCalculatorTitle"),
      "description": AppLocalizations.translate("lcCalculatorDescription"),
      "imageUrl": "assets/images/lc_calculator_image.jpg",
      "buttonText": AppLocalizations.translate("calculateLC"),
      "route": "/lc-broth-calculator",
      "iconName": "science",
      "color": AppTheme.secondaryLight,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 4.h),
                  _buildWelcomeSection(),
                  SizedBox(height: 3.h),
                  _buildCalculatorCards(),
                  SizedBox(height: 4.h),
                  _buildHistoryButton(),
                  SizedBox(height: 2.h),
                  _buildSupportButton(),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _buildSettingsFAB(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FungiNautas',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                AppLocalizations.translate('appTitle'),
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/settings'),
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.primaryColor.withOpacity(0.1),
            AppTheme.lightTheme.colorScheme.tertiary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'calculate',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  AppLocalizations.translate("precisionCultivationTools"),
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            AppLocalizations.translate("precisionCultivationToolsDescription"),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.translate("selectCalculator"),
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: calculatorOptions.length,
          separatorBuilder: (context, index) => SizedBox(height: 3.h),
          itemBuilder: (context, index) {
            final calculator = calculatorOptions[index];
            return CalculatorCardWidget(
              title: calculator["title"] as String,
              description: calculator["description"] as String,
              imageUrl: calculator["imageUrl"] as String,
              buttonText: calculator["buttonText"] as String,
              iconName: calculator["iconName"] as String,
              color: calculator["color"] as Color,
              onTap: () => _navigateToCalculator(calculator["route"] as String),
              onLongPress: () => _showCalculatorInfo(calculator),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHistoryButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => Navigator.pushNamed(context, '/calculation-history'),
        icon: CustomIconWidget(
          iconName: 'history',
          color: AppTheme.lightTheme.primaryColor,
          size: 5.w,
        ),
        label: Text(
          AppLocalizations.translate("viewCalculationHistory"),
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          side: BorderSide(
            color: AppTheme.lightTheme.primaryColor,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildSupportButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => Navigator.pushNamed(context, '/support'),
        icon: CustomIconWidget(
          iconName: 'support_agent',
          color: Colors.green,
          size: 5.w,
        ),
        label: Text(
          AppLocalizations.translate('support'),
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: Colors.green,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          side: BorderSide(
            color: Colors.green,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsFAB() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, '/settings'),
      backgroundColor: AppTheme.lightTheme.primaryColor,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      child: CustomIconWidget(
        iconName: 'tune',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 6.w,
      ),
    );
  }

  void _navigateToCalculator(String route) {
    Navigator.pushNamed(context, route);
  }

  void _showCalculatorInfo(Map<String, dynamic> calculator) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: calculator["iconName"] as String,
                color: calculator["color"] as Color,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  calculator["title"] as String,
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Text(
            calculator["description"] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToCalculator(calculator["route"] as String);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: calculator["color"] as Color,
                foregroundColor: Colors.white,
              ),
              child: Text(calculator["buttonText"] as String),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Calculator options refreshed',
            style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
          ),
          backgroundColor: AppTheme.lightTheme.snackBarTheme.backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}

