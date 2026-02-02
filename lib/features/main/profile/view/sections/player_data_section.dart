import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/profile_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayerDataSection extends StatelessWidget {
  final PlayerSpecificData data;
  final ThemeData theme;
  final S string;

  const PlayerDataSection({
    super.key,
    required this.data,
    required this.theme,
    required this.string,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.position != null)
                  _buildInfoRow(string.position, data.position!),
                if (data.age != null)
                  _buildInfoRow(string.age, '${data.age} ${string.yearsOfExperience0to2.split(' ')[1]}'),
                  //TODO the skills fields will be deleted and replace with the age field
                // if (data.preferredFoot != null)
                //   _buildInfoRow(string.skills, data.preferredFoot!),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.height != null)
                  _buildInfoRow(string.height, '${data.height}'),
                if (data.weight != null)
                  _buildInfoRow(string.weight, '${data.weight}'),
              ],
            ),
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
                color: theme.colorScheme.onTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}