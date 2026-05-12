import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnalysisTypeBadge extends StatelessWidget {
  final String type;

  const AnalysisTypeBadge({super.key, required this.type});

  // Color _color() {
  //   switch (type) {
  //     case 'Goalkeeper':
  //       return const Color(0xFF6C63FF);
  //     case 'Passing':
  //       return const Color(0xFF00BFA5);
  //     case 'Dribbling':
  //       return const Color(0xFFFF6F00);
  //     case 'Match':
  //       return const Color(0xFFE53935);
  //     default:
  //       return Colors.grey;
  //   }
  // }

  IconData _icon() {
    switch (type) {
      case 'Goalkeeper':
        return Icons.sports_handball;
      case 'Passing':
        return Icons.swap_horiz_rounded;
      case 'Dribbling':
        return Icons.directions_run_rounded;
      case 'Match':
        return Icons.sports_soccer;
      default:
        return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon(), size: 12.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            type,
            style: TextStyle(
              fontSize: 11.sp,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}