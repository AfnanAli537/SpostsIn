import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/profile_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScoutDataSection extends StatelessWidget {
  final ScoutSpecificData data;
  final ThemeData theme;
  final S string;

  const ScoutDataSection({
    super.key,
    required this.data,
    required this.theme,
    required this.string,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.specializedSport != null)
            _buildInfoRow(string.specializedSport, data.specializedSport!),
          if (data.yearsOfExperience != null)
            _buildInfoRow(
              string.yearsOfExperience,
              data.yearsOfExperience.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(width: 18.w),
          Expanded(
            child: Text(
              value,
              softWrap: true,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}