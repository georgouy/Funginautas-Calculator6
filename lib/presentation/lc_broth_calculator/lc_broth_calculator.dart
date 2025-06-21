import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/app_export.dart';
import './widgets/ingredient_toggle_widget.dart';
import './widgets/percentage_selector_widget.dart';

class LcBrothCalculator extends StatefulWidget {
  const LcBrothCalculator({super.key});

  @override
  State<LcBrothCalculator> createState() => _LcBrothCalculatorState();
}

class _LcBrothCalculatorState extends State<LcBrothCalculator> {
  final TextEditingController _waterController = TextEditingController();
  final FocusNode _waterFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _resultsKey = GlobalKey();

  String _selectedIngredient = 'Honey';
  double _selectedPercentage = 2.0;
  bool _isCalculating = false;
  bool _hasResults = false;

  Map<String, dynamic>? _calculationResults;
  String? _waterError;

  // Mock calculation history data
  final List<Map<String, dynamic>> _calculationHistory = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _waterController.addListener(_validateWaterInput);
  }

  @override
  void dispose() {
    _waterController.dispose();
    _waterFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _selectedIngredient = prefs.getString('lc_ingredient') ?? 'Honey';
        _selectedPercentage = prefs.getDouble('lc_percentage') ?? 2.0;
      });
    } catch (e) {
      // Handle error silently, use defaults
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lc_ingredient', _selectedIngredient);
      await prefs.setDouble('lc_percentage', _selectedPercentage);
    } catch (e) {
      // Handle error silently
    }
  }

  void _validateWaterInput() {
    final text = _waterController.text.trim();
    setState(() {
      if (text.isEmpty) {
        _waterError = null;
      } else {
        final value = double.tryParse(text);
        if (value == null) {
          _waterError = AppLocalizations.translate("pleaseEnterValidNumber");
        } else if (value <= 0) {
          _waterError = AppLocalizations.translate("waterAmountGreaterThanZero");
        } else if (value > 10000) {
          _waterError = AppLocalizations.translate("waterAmountTooLarge");
        } else {
          _waterError = null;
        }
      }
    });
  }

  bool get _canCalculate {
    final text = _waterController.text.trim();
    if (text.isEmpty) return false;
    final value = double.tryParse(text);
    return value != null && value > 0 && value <= 10000 && _waterError == null;
  }

  Future<void> _performCalculation() async {
    if (!_canCalculate) return;

    setState(() {
      _isCalculating = true;
    });

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Simulate calculation delay
    await Future.delayed(const Duration(milliseconds: 800));

    final waterAmount = double.parse(_waterController.text.trim());
    final ingredientAmount = (waterAmount * _selectedPercentage / 100);

    final results = {
      'waterAmount': waterAmount,
      'ingredientType': _selectedIngredient,
      'ingredientAmount': ingredientAmount,
      'percentage': _selectedPercentage,
      'timestamp': DateTime.now(),
      'totalVolume': waterAmount,
    };

    setState(() {
      _calculationResults = results;
      _hasResults = true;
      _isCalculating = false;
    });

    // Save preferences
    await _savePreferences();

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Show scroll indicator and auto-scroll to results
    _showScrollIndicatorAndScroll();
  }

  void _showScrollIndicatorAndScroll() {
    // Show snackbar with scroll instruction
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                AppLocalizations.translate('scrollToSeeResults'),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );

    // Auto-scroll to results after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (_resultsKey.currentContext != null) {
        Scrollable.ensureVisible(
          _resultsKey.currentContext!,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _clearCalculation() {
    _waterController.clear();
    setState(() {
      _calculationResults = null;
      _hasResults = false;
      _waterError = null;
    });
    _waterFocusNode.requestFocus();
  }

  Future<void> _saveToHistory() async {
    if (_calculationResults == null) return;

    final historyItem = Map<String, dynamic>.from(_calculationResults!);
    historyItem['id'] = DateTime.now().millisecondsSinceEpoch;

    setState(() {
      _calculationHistory.insert(0, historyItem);
    });

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calculation saved to history'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    HapticFeedback.selectionClick();
  }

  void _shareResults() async {
    if (_calculationResults == null) return;

    final results = _calculationResults!;
    final shareText = '''LC Broth Calculator Results

Water: ${results['waterAmount'].toStringAsFixed(1)} ml
${results['ingredientType']}: ${results['ingredientAmount'].toStringAsFixed(2)} g
Percentage: ${results['percentage'].toStringAsFixed(1)}%
Total Volume: ${results['totalVolume'].toStringAsFixed(1)} ml

Generated by FungiNautas Calculator''';

    try {
      await Share.share(
        shareText,
        subject: 'LC Broth Recipe',
      );
      HapticFeedback.selectionClick();
    } catch (e) {
      // Fallback to clipboard if share fails
      Clipboard.setData(ClipboardData(text: shareText));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recipe copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.translate('lcCalculatorTitle'),
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).appBarTheme.foregroundColor ?? Colors.white,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: Theme.of(context).appBarTheme.elevation,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header section
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'science',
                        color: Theme.of(context).colorScheme.primary,
                        size: 12.w,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        AppLocalizations.translate('lcCalculatorTitle'),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        AppLocalizations.translate('lcCalculatorDescription'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 4.h),

                // Ingredient selection
                IngredientToggleWidget(
                  selectedIngredient: _selectedIngredient,
                  onIngredientChanged: (ingredient) {
                    setState(() {
                      _selectedIngredient = ingredient;
                    });
                  },
                ),

                SizedBox(height: 3.h),

                // Percentage selection
                PercentageSelectorWidget(
                  selectedPercentage: _selectedPercentage,
                  onPercentageChanged: (percentage) {
                    setState(() {
                      _selectedPercentage = percentage;
                    });
                  },
                ),

                SizedBox(height: 3.h),

                // Water input
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _waterError != null
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 1.h),
                        child: Text(
                          AppLocalizations.translate("waterAmount"),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: TextFormField(
                          controller: _waterController,
                          focusNode: _waterFocusNode,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: InputDecoration(
                            hintText: AppLocalizations.translate("enterWaterAmount"),
                            border: InputBorder.none,
                            suffixIcon: _waterController.text.isNotEmpty
                                ? IconButton(
                                    icon: CustomIconWidget(
                                      iconName: 'clear',
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      size: 20,
                                    ),
                                    onPressed: _clearCalculation,
                                  )
                                : null,
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      if (_waterError != null)
                        Padding(
                          padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.h),
                          child: Text(
                            _waterError!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        )
                      else
                        SizedBox(height: 2.h),
                    ],
                  ),
                ),

                SizedBox(height: 4.h),

                // Calculate button
                SizedBox(
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _canCalculate && !_isCalculating ? _performCalculation : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isCalculating
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                AppLocalizations.translate('calculating'),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'calculate',
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 24,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                AppLocalizations.translate('calculateLC'),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                // Results section
                if (_hasResults && _calculationResults != null) ...[
                  SizedBox(height: 4.h),

                  // Results key for scrolling
                  Container(
                    key: _resultsKey,
                    child: Text(
                      AppLocalizations.translate('calculatedAmounts'),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Results card
                  Card(
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
                            AppTheme.lightTheme.colorScheme.primary.withOpacity(0.05),
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
                                  color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  _buildResultRow('Water', '${_calculationResults!['waterAmount'].toStringAsFixed(1)} ml', 'water_drop', Colors.blue),
                                  Divider(height: 2.h),
                                  _buildResultRow(_calculationResults!['ingredientType'] as String, '${_calculationResults!['ingredientAmount'].toStringAsFixed(2)} g', 'local_florist', Colors.orange),
                                  Divider(height: 2.h),
                                  _buildResultRow('Concentration', '${_calculationResults!['percentage'].toStringAsFixed(1)}%', 'percent', Colors.green),
                                  Divider(height: 2.h),
                                  _buildResultRow('Total Volume', '${_calculationResults!['totalVolume'].toStringAsFixed(1)} ml', 'science', AppTheme.lightTheme.colorScheme.secondary),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _saveToHistory,
                          icon: CustomIconWidget(
                            iconName: 'save',
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          label: Text(AppLocalizations.translate('saveToHistory')),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _shareResults,
                          icon: CustomIconWidget(
                            iconName: 'share',
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          label: Text(AppLocalizations.translate('shareRecipe')),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, String iconName, Color color) {
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
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

