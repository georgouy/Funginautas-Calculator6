import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _backgroundFadeAnimation;

  bool _initializationComplete = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Fade animation controller
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Background fade animation
    _backgroundFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate initialization tasks
      await Future.wait([
        _loadCalculationFormulas(),
        _initializeSharedPreferences(),
        _prepareLocalizationResources(),
        _loadAppConfiguration(),
      ]);

      // Minimum splash duration
      await Future.delayed(const Duration(milliseconds: 2500));

      if (mounted) {
        setState(() {
          _initializationComplete = true;
        });
        _navigateToDashboard();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to initialize app. Please try again.';
        });
        _showRetryOption();
      }
    }
  }

  Future<void> _loadCalculationFormulas() async {
    // Simulate loading calculation formulas
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _initializeSharedPreferences() async {
    // Simulate SharedPreferences initialization
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _prepareLocalizationResources() async {
    // Simulate localization preparation
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _loadAppConfiguration() async {
    // Simulate app configuration loading
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void _showRetryOption() {
    Timer(const Duration(seconds: 3), () {
      if (mounted && _hasError) {
        _showRetryDialog();
      }
    });
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Initialization Failed',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            _errorMessage,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _retryInitialization();
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
      _initializationComplete = false;
    });
    _initializeApp();
  }

  void _navigateToDashboard() {
    _fadeAnimationController.forward().then((_) {
      if (mounted) {
        Navigator.pushReplacementNamed(
            context, '/calculator-selector-dashboard');
      }
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.primaryLight,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _fadeAnimationController,
          builder: (context, child) {
            return Opacity(
              opacity: 1.0 - _backgroundFadeAnimation.value,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.primaryLight,
                      AppTheme.primaryVariantLight,
                      AppTheme.secondaryLight.withValues(alpha: 0.8),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo section
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _logoAnimationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _logoScaleAnimation.value,
                                child: Opacity(
                                  opacity: _logoFadeAnimation.value,
                                  child: _buildLogoSection(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Loading section
                      Expanded(
                        flex: 1,
                        child: _buildLoadingSection(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // App logo with mushroom imagery
        Image.asset(
          'assets/images/splash_screen_logo.png',
          width: 35.w,
          height: 35.w,
        ),

        SizedBox(height: 4.h),

        // App name
        Text(
          'FungiNautas',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.onPrimaryLight,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),

        SizedBox(height: 1.h),

        // App subtitle
        Text(
          'Calculator',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.onPrimaryLight.withValues(alpha: 0.8),
            fontWeight: FontWeight.w300,
            letterSpacing: 2.0,
          ),
        ),

        SizedBox(height: 2.h),

        // Tagline
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.accentLight.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.accentLight.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            'Precision in Cultivation',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.onPrimaryLight,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    if (_hasError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            color: AppTheme.errorLight,
            size: 8.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Initialization Failed',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onPrimaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Retrying in a moment...',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.onPrimaryLight.withValues(alpha: 0.7),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Loading indicator
        SizedBox(
          width: 8.w,
          height: 8.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.accentLight,
            ),
            backgroundColor: AppTheme.onPrimaryLight.withValues(alpha: 0.2),
          ),
        ),

        SizedBox(height: 3.h),

        // Loading text
        Text(
          _getLoadingText(),
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.onPrimaryLight.withValues(alpha: 0.9),
            fontWeight: FontWeight.w400,
          ),
        ),

        SizedBox(height: 1.h),

        // Loading subtitle
        Text(
          'Preparing your cultivation tools...',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.onPrimaryLight.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  String _getLoadingText() {
    if (_initializationComplete) {
      return 'Ready to Calculate!';
    }
    return 'Loading Formulas...';
  }
}
