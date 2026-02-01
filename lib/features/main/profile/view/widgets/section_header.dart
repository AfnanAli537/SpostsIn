import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onShowAllPressed;

  const SectionHeader({
    super.key,
    required this.title,
    this.onShowAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (onShowAllPressed != null)
            TextButton(
              onPressed: onShowAllPressed,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(50.w, 30.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                string.showAll,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}