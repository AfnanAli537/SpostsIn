import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDescription extends StatelessWidget {
  final String description;

  const ProfileDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEmpty = description.trim().isEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.r),
      child: Text(
        isEmpty ? 'No bio' : description,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isEmpty 
            ? theme.colorScheme.onError.withOpacity(0.5)
            : theme.colorScheme.onSurface,
          fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
          height: 1.4.h,
        ),
      ),
    );
  }
}