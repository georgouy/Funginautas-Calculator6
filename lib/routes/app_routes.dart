import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/calculation_history/calculation_history.dart';
import '../presentation/calculator_selector_dashboard/calculator_selector_dashboard.dart';
import '../presentation/lc_broth_calculator/lc_broth_calculator.dart';
import '../presentation/settings/settings.dart';
import '../presentation/cvg_substrate_calculator/cvg_substrate_calculator.dart';
import '../presentation/error_resolution_guide/error_resolution_guide.dart';
import '../presentation/support/support_page.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String calculatorSelectorDashboard =
      '/calculator-selector-dashboard';
  static const String cvgSubstrateCalculator = '/cvg-substrate-calculator';
  static const String lcBrothCalculator = '/lc-broth-calculator';
  static const String calculationHistory = '/calculation-history';
  static const String settings = '/settings';
  static const String errorResolutionGuide = '/error-resolution-guide';
  static const String support = '/support';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    calculatorSelectorDashboard: (context) =>
        const CalculatorSelectorDashboard(),
    cvgSubstrateCalculator: (context) => const CvgSubstrateCalculator(),
    lcBrothCalculator: (context) => const LcBrothCalculator(),
    calculationHistory: (context) => const CalculationHistory(),
    settings: (context) => const Settings(),
    errorResolutionGuide: (context) => const ErrorResolutionGuide(),
    support: (context) => const SupportPage(),
  };
}

