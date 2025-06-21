import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../error_resolution_guide.dart';
import './severity_badge_widget.dart';
import './solution_card_widget.dart';

// lib/presentation/error_resolution_guide/widgets/error_section_widget.dart

class ErrorSectionWidget extends StatefulWidget {
  final ErrorSection errorSection;
  final Function(String) onCopyCommand;
  final Function(String) onQuickFix;

  const ErrorSectionWidget({
    super.key,
    required this.errorSection,
    required this.onCopyCommand,
    required this.onQuickFix,
  });

  @override
  State<ErrorSectionWidget> createState() => _ErrorSectionWidgetState();
}

class _ErrorSectionWidgetState extends State<ErrorSectionWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SeverityBadgeWidget(
                          severity: widget.errorSection.severity),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          widget.errorSection.title,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 24.sp,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.errorSection.description,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withAlpha(77),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.errorSection.category,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Solutions (${widget.errorSection.solutions.length})',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...widget.errorSection.solutions.asMap().entries.map(
                    (entry) {
                      final index = entry.key;
                      final solution = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              index < widget.errorSection.solutions.length - 1
                                  ? 16.h
                                  : 0,
                        ),
                        child: SolutionCardWidget(
                          solution: solution,
                          index: index + 1,
                          onCopyCommand: widget.onCopyCommand,
                          onQuickFix: () => widget
                              .onQuickFix('${widget.errorSection.id}_$index'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
}
