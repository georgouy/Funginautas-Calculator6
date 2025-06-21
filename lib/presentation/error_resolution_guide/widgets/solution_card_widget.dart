// lib/presentation/error_resolution_guide/widgets/solution_card_widget.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../error_resolution_guide.dart';

class SolutionCardWidget extends StatelessWidget {
  final ErrorSolution solution;
  final int index;
  final Function(String) onCopyCommand;
  final VoidCallback onQuickFix;

  const SolutionCardWidget({
    super.key,
    required this.solution,
    required this.index,
    required this.onCopyCommand,
    required this.onQuickFix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(77),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: theme.colorScheme.outline.withAlpha(51), width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                    color: theme.colorScheme.primary, shape: BoxShape.circle),
                child: Center(
                    child: Text(index.toString(),
                        style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onPrimary)))),
            SizedBox(width: 12.w),
            Expanded(
                child: Text(solution.title,
                    style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface))),
            IconButton(
                onPressed: onQuickFix,
                icon: Icon(Icons.play_circle_outline,
                    color: theme.colorScheme.primary, size: 20.sp),
                tooltip: 'Quick Fix'),
          ]),
          SizedBox(height: 8.h),
          Text(solution.description,
              style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4)),
          if (solution.commands.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text('Commands:',
                style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface)),
            SizedBox(height: 8.h),
            ...solution.commands
                .map((command) => _buildCommandItem(context, command, theme)),
          ],
          if (solution.codeSnippet != null) ...[
            SizedBox(height: 12.h),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Code Example:',
                  style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface)),
              TextButton.icon(
                  onPressed: () => onCopyCommand(solution.codeSnippet!),
                  icon: Icon(Icons.copy, size: 16.sp),
                  label: Text('Copy',
                      style: GoogleFonts.inter(
                          fontSize: 12.sp, fontWeight: FontWeight.w500)),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 4.h))),
            ]),
            SizedBox(height: 8.h),
            Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: theme.colorScheme.outline.withAlpha(77),
                        width: 1)),
                child: Text(solution.codeSnippet!,
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurface,
                        height: 1.4))),
          ],
        ]));
  }

  Widget _buildCommandItem(
      BuildContext context, String command, ThemeData theme) {
    return Padding(
        padding: EdgeInsets.only(bottom: 4.h),
        child: Row(children: [
          Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                  color: theme.colorScheme.primary, shape: BoxShape.circle)),
          SizedBox(width: 8.w),
          Expanded(
              child: Text(command,
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurfaceVariant))),
          IconButton(
              onPressed: () => onCopyCommand(command),
              icon: Icon(Icons.copy,
                  size: 16.sp, color: theme.colorScheme.onSurfaceVariant),
              tooltip: 'Copy Command',
              constraints: BoxConstraints(minWidth: 24.w, minHeight: 24.w),
              padding: EdgeInsets.zero),
        ]));
  }
}
