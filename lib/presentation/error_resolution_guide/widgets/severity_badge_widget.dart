// lib/presentation/error_resolution_guide/widgets/severity_badge_widget.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../error_resolution_guide.dart';

class SeverityBadgeWidget extends StatelessWidget {
  final ErrorSeverity severity;

  const SeverityBadgeWidget({
    super.key,
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getSeverityConfig(severity);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: config.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: 12.sp,
            color: config.iconColor,
          ),
          SizedBox(width: 4.w),
          Text(
            config.label,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: config.textColor,
            ),
          ),
        ],
      ),
    );
  }

  SeverityConfig _getSeverityConfig(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.critical:
        return SeverityConfig(
          label: 'CRITICAL',
          icon: Icons.error,
          backgroundColor: const Color(0xFFFFEBEE),
          borderColor: const Color(0xFFE57373),
          iconColor: const Color(0xFFC62828),
          textColor: const Color(0xFFC62828),
        );
      case ErrorSeverity.warning:
        return SeverityConfig(
          label: 'WARNING',
          icon: Icons.warning,
          backgroundColor: const Color(0xFFFFF8E1),
          borderColor: const Color(0xFFFFB74D),
          iconColor: const Color(0xFFE65100),
          textColor: const Color(0xFFE65100),
        );
      case ErrorSeverity.info:
        return SeverityConfig(
          label: 'INFO',
          icon: Icons.info,
          backgroundColor: const Color(0xFFE3F2FD),
          borderColor: const Color(0xFF64B5F6),
          iconColor: const Color(0xFF1565C0),
          textColor: const Color(0xFF1565C0),
        );
    }
  }
}

class SeverityConfig {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;

  SeverityConfig({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
  });
}
