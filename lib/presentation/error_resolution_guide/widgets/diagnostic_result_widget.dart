// lib/presentation/error_resolution_guide/widgets/diagnostic_result_widget.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../error_resolution_guide.dart';

class DiagnosticResultWidget extends StatelessWidget {
  final List<DiagnosticResult> results;
  final VoidCallback onClose;

  const DiagnosticResultWidget({
    super.key,
    required this.results,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withAlpha(51),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Diagnostic Results',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: Icon(
                    Icons.close,
                    size: 24.sp,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Results List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return _buildResultItem(context, result, theme);
              },
            ),
          ),

          // Footer
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withAlpha(51),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Completed ${results.length} checks',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onClose,
                  child: Text(
                    'Close',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(
      BuildContext context, DiagnosticResult result, ThemeData theme) {
    final statusConfig = _getStatusConfig(result.status);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: statusConfig.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: statusConfig.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: statusConfig.iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusConfig.icon,
              size: 18.sp,
              color: statusConfig.iconColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.name,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: statusConfig.titleColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  result.details,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: statusConfig.detailsColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DiagnosticStatusConfig _getStatusConfig(DiagnosticStatus status) {
    switch (status) {
      case DiagnosticStatus.success:
        return DiagnosticStatusConfig(
          icon: Icons.check_circle,
          backgroundColor: const Color(0xFFE8F5E8),
          borderColor: const Color(0xFF4CAF50),
          iconBackgroundColor: const Color(0xFF4CAF50),
          iconColor: Colors.white,
          titleColor: const Color(0xFF2E7D32),
          detailsColor: const Color(0xFF2E7D32),
        );
      case DiagnosticStatus.warning:
        return DiagnosticStatusConfig(
          icon: Icons.warning,
          backgroundColor: const Color(0xFFFFF8E1),
          borderColor: const Color(0xFFFF9800),
          iconBackgroundColor: const Color(0xFFFF9800),
          iconColor: Colors.white,
          titleColor: const Color(0xFFE65100),
          detailsColor: const Color(0xFFE65100),
        );
      case DiagnosticStatus.error:
        return DiagnosticStatusConfig(
          icon: Icons.error,
          backgroundColor: const Color(0xFFFFEBEE),
          borderColor: const Color(0xFFF44336),
          iconBackgroundColor: const Color(0xFFF44336),
          iconColor: Colors.white,
          titleColor: const Color(0xFFC62828),
          detailsColor: const Color(0xFFC62828),
        );
    }
  }
}

class DiagnosticStatusConfig {
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color titleColor;
  final Color detailsColor;

  DiagnosticStatusConfig({
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.titleColor,
    required this.detailsColor,
  });
}
