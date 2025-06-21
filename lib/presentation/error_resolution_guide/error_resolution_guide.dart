import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import './widgets/diagnostic_result_widget.dart';
import './widgets/error_section_widget.dart';
import './widgets/search_bar_widget.dart';

// lib/presentation/error_resolution_guide/error_resolution_guide.dart

class ErrorResolutionGuide extends StatefulWidget {
  const ErrorResolutionGuide({super.key});

  @override
  State<ErrorResolutionGuide> createState() => _ErrorResolutionGuideState();
}

class _ErrorResolutionGuideState extends State<ErrorResolutionGuide> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isRunningDiagnostics = false;
  List<DiagnosticResult> _diagnosticResults = [];

  final List<ErrorSection> _allErrors = [
    ErrorSection(
      id: 'gradle_agp',
      title: 'Android Gradle Plugin Version',
      description: 'AGP version 8.2.1 will be deprecated. Upgrade to 8.3.0+',
      severity: ErrorSeverity.warning,
      category: 'Build Configuration',
      solutions: [
        ErrorSolution(
          title: 'Update settings.gradle',
          description: 'Update AGP version in settings.gradle file',
          commands: [
            'Open android/settings.gradle',
            'Find: id "com.android.application" version "8.2.1"',
            'Replace with: id "com.android.application" version "8.3.0"'
          ],
          codeSnippet: '''plugins {
    id "com.android.application" version "8.3.0" apply false
    id "org.jetbrains.kotlin.android" version "1.7.10" apply false
}''',
        ),
        ErrorSolution(
          title: 'Update build.gradle (Legacy)',
          description:
              'For older project templates, update top-level build.gradle',
          commands: [
            'Open android/build.gradle',
            'Find: classpath \'com.android.tools.build:gradle:8.2.1\'',
            'Replace with: classpath \'com.android.tools.build:gradle:8.3.0\''
          ],
          codeSnippet: '''dependencies {
    classpath 'com.android.tools.build:gradle:8.3.0'
    classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:1.7.10"
}''',
        ),
      ],
    ),
    ErrorSection(
      id: 'sizer_error',
      title: 'Sizer Package Integration',
      description:
          'The method \'Sizer\' isn\'t defined for the class \'MyApp\'',
      severity: ErrorSeverity.critical,
      category: 'Dependency Error',
      solutions: [
        ErrorSolution(
          title: 'Add Sizer Dependency',
          description: 'Add sizer package to pubspec.yaml',
          commands: ['flutter pub add sizer', 'flutter pub get'],
          codeSnippet: '''dependencies:
  flutter:
    sdk: flutter
  sizer: ^2.0.15''',
        ),
        ErrorSolution(
          title: 'Import Sizer Package',
          description: 'Import sizer in main.dart',
          commands: ['Add import statement at top of main.dart'],
          codeSnippet: '''''',
        ),
        ErrorSolution(
          title: 'Fix Sizer Usage',
          description: 'Correct Sizer builder implementation',
          commands: ['Update MyApp build method'],
          codeSnippet: '''return Sizer(
  builder: (context, orientation, deviceType) {
    return MaterialApp(
      // Your app configuration
    );
  },
);''',
        ),
      ],
    ),
    ErrorSection(
      id: 'theme_compatibility',
      title: 'Theme Compatibility Issues',
      description: 'CardTheme, TabBarTheme, DialogTheme type mismatches',
      severity: ErrorSeverity.critical,
      category: 'Theme Configuration',
      solutions: [
        ErrorSolution(
          title: 'Fix CardTheme Type',
          description: 'Use CardThemeData instead of CardTheme',
          commands: [
            'Update app_theme.dart',
            'Replace CardTheme with CardThemeData'
          ],
          codeSnippet: '''cardTheme: CardThemeData(
  color: surfaceLight,
  surfaceTintColor: Colors.transparent,
  elevation: 2.0,
  shadowColor: shadowLight,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
),''',
        ),
        ErrorSolution(
          title: 'Fix TabBarTheme Type',
          description: 'Use TabBarThemeData instead of TabBarTheme',
          commands: [
            'Update app_theme.dart',
            'Replace TabBarTheme with TabBarThemeData'
          ],
          codeSnippet: '''tabBarTheme: TabBarThemeData(
  labelColor: primaryLight,
  unselectedLabelColor: textSecondaryLight,
  indicatorColor: primaryLight,
  indicatorSize: TabBarIndicatorSize.tab,
),''',
        ),
        ErrorSolution(
          title: 'Fix DialogTheme Type',
          description: 'Use DialogThemeData instead of DialogTheme',
          commands: [
            'Update app_theme.dart',
            'Replace DialogTheme with DialogThemeData'
          ],
          codeSnippet: '''dialogTheme: DialogThemeData(
  backgroundColor: surfaceLight,
  surfaceTintColor: Colors.transparent,
  elevation: 8.0,
  shadowColor: shadowLight,
),''',
        ),
      ],
    ),
  ];

  List<ErrorSection> get _filteredErrors {
    if (_searchQuery.isEmpty) return _allErrors;
    return _allErrors.where((error) {
      return error.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          error.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          error.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Development Support',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, size: 24.sp),
            onPressed: () => _showHelpDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SearchBarWidget(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              hintText: 'Search errors by keywords or error codes...',
            ),
          ),

          // Error Sections
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _filteredErrors.length,
              itemBuilder: (context, index) {
                final error = _filteredErrors[index];
                return ErrorSectionWidget(
                  errorSection: error,
                  onCopyCommand: _copyToClipboard,
                  onQuickFix: (solutionId) =>
                      _executeQuickFix(error.id, solutionId),
                );
              },
            ),
          ),

          // Bottom Actions
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isRunningDiagnostics ? null : _runDiagnostics,
                icon: _isRunningDiagnostics
                    ? SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Icon(Icons.bug_report, size: 18.sp),
                label: Text(
                  _isRunningDiagnostics
                      ? 'Running Diagnostics...'
                      : 'Run Diagnostics',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied to clipboard',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _executeQuickFix(String errorId, String solutionId) {
    // Simulate quick fix execution
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Executing quick fix for $errorId...',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View Progress',
          onPressed: () {},
        ),
      ),
    );
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      _isRunningDiagnostics = true;
    });

    // Simulate diagnostic checks
    await Future.delayed(const Duration(seconds: 3));

    final results = [
      DiagnosticResult(
        name: 'Flutter Version',
        status: DiagnosticStatus.success,
        details: 'Flutter 3.16.0 - Latest stable version',
      ),
      DiagnosticResult(
        name: 'Android Gradle Plugin',
        status: DiagnosticStatus.warning,
        details: 'Version 8.2.1 detected - Consider upgrading to 8.3.0+',
      ),
      DiagnosticResult(
        name: 'Dependencies',
        status: DiagnosticStatus.error,
        details: 'Sizer package issues detected in main.dart',
      ),
      DiagnosticResult(
        name: 'Theme Configuration',
        status: DiagnosticStatus.error,
        details: 'Theme type compatibility issues found',
      ),
    ];

    setState(() {
      _isRunningDiagnostics = false;
      _diagnosticResults = results;
    });

    _showDiagnosticResults();
  }

  void _showDiagnosticResults() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DiagnosticResultWidget(
        results: _diagnosticResults,
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Error Resolution Guide Help',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'This guide helps you resolve common Flutter development issues.\n\n'
          '• Use the search bar to find specific errors\n'
          '• Expand error sections to see detailed solutions\n'
          '• Copy commands to your clipboard for easy execution\n'
          '• Run diagnostics to check your project health\n'
          '• Severity badges indicate error priority',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Data Models
class ErrorSection {
  final String id;
  final String title;
  final String description;
  final ErrorSeverity severity;
  final String category;
  final List<ErrorSolution> solutions;

  ErrorSection({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.category,
    required this.solutions,
  });
}

class ErrorSolution {
  final String title;
  final String description;
  final List<String> commands;
  final String? codeSnippet;

  ErrorSolution({
    required this.title,
    required this.description,
    required this.commands,
    this.codeSnippet,
  });
}

enum ErrorSeverity {
  critical,
  warning,
  info,
}

class DiagnosticResult {
  final String name;
  final DiagnosticStatus status;
  final String details;

  DiagnosticResult({
    required this.name,
    required this.status,
    required this.details,
  });
}

enum DiagnosticStatus {
  success,
  warning,
  error,
}
